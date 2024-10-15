import 'package:bloc/bloc.dart';
import 'package:chuck2wiz/data/blocs/main/ai/form/ai_form_event.dart';
import 'package:chuck2wiz/data/repository/ai/form_repository.dart';

import 'ai_form_state.dart';

class AiFormBloc extends Bloc<AiFormEvent, AiFormState>{
  final FormRepository formRepository;

  AiFormBloc(this.formRepository): super(AiFormInitial()) {
    on<AiFormSelectOptionEvent>(_onSelectFormOption);
    on<GetAiFormDataEvent>(_onGetAiFormData);
    on<QuestionValueChangeEvent>(_onQuestionChange);
  }

  Future<void> _onSelectFormOption(AiFormSelectOptionEvent event, Emitter<AiFormState> emit) async {
    emit(state.copyWith(selectOption: event.selectOption));
  }

  Future<void> _onGetAiFormData(GetAiFormDataEvent event, Emitter<AiFormState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if(state.selectOption == null) {
        throw Exception("null Data");
      }

      final response = await formRepository.searchForm(state.selectOption!);

      if(response.success) {
        emit(state.copyWith(formData: response.data));
      } else {
        throw Exception(response.message);
      }
    } catch(e) {
      emit(AiFormFailure(error: e));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onQuestionChange(QuestionValueChangeEvent event, Emitter<AiFormState> emit) async {
    emit(state.copyWith(questionValue: event.questionValue));
  }
}
