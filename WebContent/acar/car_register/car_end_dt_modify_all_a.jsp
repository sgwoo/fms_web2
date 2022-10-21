<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
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
	
	String[] car_end_dt_arr = request.getParameterValues("car_end_dt");		
	String[] car_mng_id_arr = request.getParameterValues("car_mng_id");
	//차령만료일 1년연장에 관한 건만 카운팅VV
	String[] car_end_yn_cnt_arr = request.getParameterValues("car_end_yn_cnt");
	String car_end_yn = "";
	int cnt = car_mng_id_arr.length;
	int flagCnt = 0;
	boolean flag = false;
	boolean flag2 = false;
	boolean flagReal = false;
	String param = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=0; i < cnt; i++){
		String car_end_dt = car_end_dt_arr[i];
		String car_mng_id = car_mng_id_arr[i];
		param = param + car_mng_id + ","; 
		car_end_yn = "";
		int car_end_yn_cnt = Integer.parseInt(car_end_yn_cnt_arr[i]);
		
		//먼저 차령만료일을 업데이트
		boolean flag1 = crd.updateCarEndDt( car_end_dt, user_id, car_end_yn, car_mng_id );
		
		//자동차 번호 이력 신규등록(차령만료일 1년 연장용도)	
		if(car_end_yn_cnt > 1){
			//이미 2건이 등록되어 있으면 더 이상 생성되지 않게 처리
			flag2 = true;
		//차령만료일 연장을 2번이상 하지 않은 차량에 대해서만 신규 등록건을 생성
		}else if(car_end_yn_cnt == 0 || car_end_yn_cnt == 1){
			
			//이 차량들 중에서도 최신건의 등록증이 아직 등록되지 않은 차량은 다른 신규건이 등록되지 않게 처리
			CarHisBean ch_r [] = crd.getCarHisCarEndDt(car_mng_id);
			//int fileCnt = 0;
			cr_bean = crd.getCarRegBean(car_mng_id);
			String car_no = cr_bean.getCar_no();
			String car_ext = cr_bean.getCar_ext();
			
			if(ch_r.length > 0){	//"차령만료"의 사유로 신규등록건이 한건이라도 있는경우 - 등록증도 등록되어 있는지 조회.
				
    			ch_bean = ch_r[0];	//조회된 건들 중에서 최신의 한건만 비교하면됨.
    			String content_code = "CAR_CHANGE";
				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
				//이 건들이 등록증도 등록되어 있는지 조회
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){
					//등록증이 등록되어 있으면 신규 변경건을 새로 만듬
					flag2 = crd.insertCarHisForCarEndDt( car_mng_id, car_end_dt, car_no, user_id, car_ext);
				}else{
					//등록되어 있지않으면 생략
					flag2 = true;
				}
			}else{	//"차령만료"의 사유로 신규등록건이 한건도 없는경우
				flag2 = crd.insertCarHisForCarEndDt( car_mng_id, car_end_dt, car_no, user_id, car_ext);
			}
		}
		if(flag1==true && flag2==true ){
			flagCnt++;
		}
	}
	if(flagCnt==cnt){
		flagReal = true;
	}
%>
	<script type="text/javascript" >
		var flagReal = <%=flagReal%>;
		if(flagReal==true){
			alert("수정되었습니다.");
		}else{
			alert("수정 중 오류발생! \n\n관리자에게 문의하세요.");
		}
		var param = '<%=param%>';
		//window.opener.document.location.reload();
		window.opener.document.location.href = 'car_end_dt_modify_all.jsp?param='+param+'&modi_chk=1';
		window.close();
	</script>
<%	
%>	
</body>
</html>