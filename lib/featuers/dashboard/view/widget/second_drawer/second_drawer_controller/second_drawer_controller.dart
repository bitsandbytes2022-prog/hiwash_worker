import 'package:get/get.dart';
import '../../../../../../network_manager/repository.dart';
import '../model/faq_response_model.dart';
import '../model/guides_response_model.dart';

class SecondDrawerController extends GetxController {
  var isChecked = [true, false, false].obs;
  Rxn<FaqResponseModel> faqResponse = Rxn();
  Rxn<GuidesResponseModel> guidesResponseModel = Rxn();
  RxBool isLoading = true.obs;
  RxList<bool> isExpanded = <bool>[].obs;
  RxString searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getGuides();
  }

  void toggleCheckbox(int index) {
    for (int i = 0; i < isChecked.length; i++) {
      isChecked[i] = (i == index);
    }
  }



  void toggleExpand(int index) {
    isExpanded[index] = !isExpanded[index];
  }

  Future<FaqResponseModel?> getFaq() async {
    isLoading.value = true;
    try {
      int entityType = 0;
      faqResponse.value = await Repository().getFaq(entityType);

      isExpanded.value = List<bool>.filled(
        faqResponse.value?.data?.length ?? 0,
        false,
      );
      //return faqResponse.value;
    } catch (error) {
      print("Error fetching FAQ: $error");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<GuidesResponseModel?> getGuides() async {
    int entityType = 1;

    guidesResponseModel.value = await Repository().getGuides(entityType);
    return guidesResponseModel.value;
  }
}
