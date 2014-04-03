#ifndef OVRVISION_H
#define OVRVISION_H

#include <QQuickPaintedItem>
#include <memory>
#include <thread>
#include <ovrvision.h>
#include <opencv2/opencv.hpp>


class OVRVision
{
public:
    static bool isReady();

    static void getLeftImage(unsigned char* dest);
    static void getRightImage(unsigned char* dest);

private:
    OVRVision();
    OVRVision(const OVRVision& other);
    OVRVision& operator=(const OVRVision& other);
    static const std::shared_ptr<OVR::Ovrvision>& getInstance();
    static std::shared_ptr<OVR::Ovrvision> instance;
    static cv::Mat ovrLeftImg, ovrRightImg;
};


class OVRVisionItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(bool isCanny MEMBER isCanny_)
    Q_PROPERTY(bool isBitwiseNot MEMBER isBitwiseNot_)
    Q_PROPERTY(bool isMedianBlur MEMBER isMedianBlur_)
    Q_PROPERTY(double cannyThreashold1 MEMBER cannyThreshold1_)
    Q_PROPERTY(double cannyThreashold2 MEMBER cannyThreshold2_)
    Q_PROPERTY(double medianBlurSize MEMBER medianBlurSize_)
    Q_PROPERTY(int camera MEMBER camera_)
    Q_ENUMS(Camera)

public:
    enum Camera { Left = 0, Right = 1 };
    explicit OVRVisionItem(QQuickItem* parent = 0);
    void paint(QPainter* painter);

private:
    int camera_;
    bool isCanny_;
    bool isBitwiseNot_;
    bool isMedianBlur_;
    double cannyThreshold1_, cannyThreshold2_;
    double medianBlurSize_;
    std::thread thread_;
    cv::Mat img_;
};


#endif // OVRVISION_H
