from rest_framework_simplejwt.exceptions import InvalidToken, AuthenticationFailed
from rest_framework.views import exception_handler
from rest_framework.response import Response

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    if response is not None and response.status_code == 401:
            if isinstance(exc, (InvalidToken, AuthenticationFailed)):
                detail = exc.detail if hasattr(exc, 'detail') else exc
                if isinstance(detail, dict):
                    if 'messages' in detail and isinstance(detail['messages'], list) and detail['messages']:
                        msg = detail['messages'][0].get('message', str(detail))
                        if hasattr(msg, 'title'):
                            msg = msg.title()
                        return Response({
                            'code': 'invalid_access',
                            'message': str(msg)
                        }, status=401)
                    if 'detail' in detail:
                        return Response({
                            'code': 'invalid_access',
                            'message': str(detail['detail'])
                        }, status=401)
                    if 'message' in detail:
                        return Response({
                            'code': 'invalid_access',
                            'message': str(detail['message'])
                        }, status=401)
                    return Response({
                        'code': 'invalid_access',
                        'message': str(detail)
                    }, status=401)
                return Response({
                    'code': 'invalid_access',
                    'message': str(detail)
                }, status=401)
    return response
