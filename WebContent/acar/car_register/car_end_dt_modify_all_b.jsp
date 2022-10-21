<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
			
	String[] car_mng_id_arr = request.getParameterValues("car_mng_id");
	int cnt = car_mng_id_arr.length;	
	boolean flag = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=0; i < cnt; i++){	//연번에 따른 각 건을 for문 돌림
		String car_mng_id = car_mng_id_arr[i];
		//"차령만료일 연장"으로 번호변경 이 있는건만 조회
		CarHisBean ch_r [] = crd.getCarHisCarEndDt(car_mng_id);
		int fileCnt = 0;
		if(ch_r.length > 0){
    		for(int j=0; j<ch_r.length; j++){
    			ch_bean = ch_r[j];
    			String content_code = "CAR_CHANGE";
				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
				//이 건들이 등록증도 등록되어 있는지 조회
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				int attach_vt_size = attach_vt.size();
				if(attach_vt_size > 0){
					fileCnt ++;
				}
    		}
		}
		if(fileCnt >= 2){	//등록증 2건 이상 이면 2회연장종료 처리 
			flag = crd.updateCarEndYn(user_id, car_mng_id);
		}
	}
%>
	<script type="text/javascript" >
		var flag = <%=flag%>;
		if(flag==true){
			alert("갱신되었습니다.");
		}else{
			alert("갱신 중 오류발생! \n\n관리자에게 문의하세요.");
		}
		window.opener.document.location.reload();
		window.close();
	</script>
<%	
%>	
</body>
</html>