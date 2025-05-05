class ApiConstant{

static const baseUrl="https://loyaltyapistaging.pipelinedns.com/api";

static const  baseImageUrl = "https://loyaltyapistaging.pipelinedns.com";

static const sendOtp="$baseUrl/authentication/send-otp";
static const getToken="$baseUrl/authentication/token";
static  getWorkerId(int id)=>"$baseUrl/worker/$id";
static  getCustomerId(int id)=>"$baseUrl/customer/$id";
static  getFaq(int entityType)=>"/content/faqs?entityType=$entityType";
static  getGuides(int entityType)=>"/content/guides?entityType=$entityType";
static  getTermsAndConditions(int entityType)=>"/content/termsandconditions?entityType=$entityType";
static const uploadProfileImage="$baseUrl/worker/upload-profile-picture";
static const uploadProfile="$baseUrl/worker/update-profile";
static const validateWashQr="$baseUrl/worker/validate-wash-qr";
static const todayWashSummary="$baseUrl/worker/wash-summary";
static const completeWash="$baseUrl/worker/complete-wash";
static const washLog="$baseUrl/worker/wash-log";
static  getOffersById(int id)=>"$baseUrl/offer/$id";








}