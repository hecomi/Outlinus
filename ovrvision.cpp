#include "ovrvision.h"
#include <opencv2/opencv.hpp>
#include <QImage>
#include <QPainter>

/* --------------------------------------------------------------------------------
 * OVRVisionItem
 * -------------------------------------------------------------------------------- */
std::shared_ptr<OVR::Ovrvision> OVRVision::instance;

const std::shared_ptr<OVR::Ovrvision>& OVRVision::getInstance()
{
    if (!instance) {
        instance = std::shared_ptr<OVR::Ovrvision>(new OVR::Ovrvision(), [](OVR::Ovrvision* ptr) {
            ptr->Close();
        });
        instance->Open(0, OVR::OV_CAMVGA_FULL);
    }
    return instance;
}

bool OVRVision::isReady()
{
    return getInstance();
}

void OVRVision::getLeftImage(unsigned char* dest)
{
    getInstance()->GetCamImage(dest, OVR::OV_CAMEYE_LEFT);
}

void OVRVision::getRightImage(unsigned char* dest)
{
    getInstance()->GetCamImage(dest, OVR::OV_CAMEYE_RIGHT);
}


/* --------------------------------------------------------------------------------
 * OVRVisionItem
 * -------------------------------------------------------------------------------- */
namespace {
    int OVR_CAM_WIDTH  = 640;
    int OVR_CAM_HEIGHT = 480;
}

OVRVisionItem::OVRVisionItem(QQuickItem *parent) :
    QQuickPaintedItem(parent), camera_(Left),
    isCanny_(false), isMedianBlur_(false), isBitwiseNot_(false),
    cannyThreshold1_(50.0), cannyThreshold2_(200.0),
    medianBlurSize_(7.0)
{
}

void OVRVisionItem::paint(QPainter *painter)
{
    if (thread_.joinable()) {
        thread_.join();
    }
    thread_ = std::thread([this] {
        cv::Mat ovrImg(OVR_CAM_HEIGHT, OVR_CAM_WIDTH, CV_8UC3);

        if (OVRVision::isReady()) {
            switch (camera_) {
                case Left:  OVRVision::getLeftImage(ovrImg.data);  break;
                case Right: OVRVision::getRightImage(ovrImg.data); break;
            }
            if (isCanny_) {
                cv::Mat cannyImg;
                cv::Canny(ovrImg, cannyImg, cannyThreshold1_, cannyThreshold2_);
                cv::cvtColor(cannyImg, ovrImg, CV_GRAY2BGR);
            }
            if (isBitwiseNot_) {
                cv::bitwise_not(ovrImg, ovrImg);
            }
            if (isMedianBlur_) {
                cv::medianBlur(ovrImg, ovrImg, medianBlurSize_);
            }
            cv::cvtColor(ovrImg, ovrImg, CV_BGR2RGBA);
        }
        img_ = ovrImg;
    });

    if (img_.empty()) return;

    cv::Mat ovrScaledImg(height(), width(), img_.type());
    cv::resize(img_, ovrScaledImg, ovrScaledImg.size(), cv::INTER_CUBIC);
    QImage qmlImg(ovrScaledImg.data, ovrScaledImg.cols, ovrScaledImg.rows, QImage::Format_ARGB32);
    // qmlImg = qmlImg.scaled(width(), height()); // <-- slow
    painter->drawImage(width()/2  - qmlImg.size().width()/2,
                       height()/2 - qmlImg.size().height()/2,
                       qmlImg);
}
