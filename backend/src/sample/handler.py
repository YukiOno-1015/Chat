import json
from common import (
    log_event,
    create_response,
    get_query_params,
    get_request_body,
    get_request_headers,
    get_path_params
)

def main(event, context):
    # API Gatewayプロキシ統合のイベントを処理
    log_event(event)

    # クエリパラメータを取得
    query_params = get_query_params(event)

    # リクエストボディを取得
    body = get_request_body(event)

    # リクエストヘッダーを取得
    headers = get_request_headers(event)

    # リクエストパスパラメータを取得
    path_params = get_path_params(event)

    # レスポンスボディを作成
    response_body = {
        "message": "Hello from Lambda!",
        "query_params": query_params,
        "body": body,
        "headers": headers,
        "path_params": path_params
    }

    # レスポンスを作成
    response = create_response(200, response_body)

    return response
