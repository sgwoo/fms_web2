<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_num_area = 	request.getParameter("car_num_area")==null?"":request.getParameter("car_num_area");
	String car_num_ko = 	request.getParameter("car_num_ko")==null?"":request.getParameter("car_num_ko");
	String car_num_first = 	request.getParameter("car_num_first")==null?"":request.getParameter("car_num_first");
	String car_num_last = 	request.getParameter("car_num_last")==null?"":request.getParameter("car_num_last");
	String reg_dt = 		request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String end_dt = 		request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_ext = 		request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String fn = 			request.getParameter("fn")==null?"":request.getParameter("fn");
	String param = 			request.getParameter("param")==null?"":request.getParameter("param");
	String alertText = "";
	int count1 = 0;
	int count2 = 0;
	int numCount = 0;
	int cnt2 = 0;
	String[] seq_arr = null;
	if(fn.equals("reg_new_car_no")){	//신규 자동차 번호 등록(범위로)
		for(int i=Integer.parseInt(car_num_first); i<=Integer.parseInt(car_num_last); i++){
			//생성할 번호 개수를 구함
			numCount = Integer.parseInt(car_num_last) - Integer.parseInt(car_num_first) + 1 ;
			
			//번호 조합
			String empty_num = "";	//앞자리가 0인경우 차량번호4자리 맞춰주기(20181127)
			if(String.valueOf(i).length()==1){		empty_num = "000"; 	}
			else if(String.valueOf(i).length()==2){	empty_num = "00"; 	}
			else if(String.valueOf(i).length()==3){	empty_num = "0"; 	}
			
			String car_num = car_num_area + car_num_ko + empty_num + i;
			//먼저 조합한 번호의 이미존재 유무 체크
			Vector lists = sc_db.getNewCarNumList("","","","3","",car_num);
			if(lists.isEmpty()){	//없으면 번호생성
				//번호 생성
				int result = sc_db.newCarNumReg(car_num, reg_dt, end_dt, car_ext);
				if(result == 1) {count1 ++;}
			}else{	//이미 존재하면 카운트만
				alertText += car_num + ", ";
				count1 ++;
			}
		}
	}else if(fn.equals("save_car_no_stat")){	//배정구분 일괄변경
		if(param.equals("2")){
			seq_arr = request.getParameterValues("list_seq");
		}else{
			seq_arr = request.getParameterValues("seq");
		}
		String[] car_no_stat_arr = request.getParameterValues("car_no_stat");
		cnt2 = car_no_stat_arr.length;
		for(int i=0; i < cnt2; i++){
			String seq = seq_arr[i];
			String car_no_stat = car_no_stat_arr[i];
			int flag2 = sc_db.updateCarNoStat(car_no_stat, seq);
			
			if(flag2==1){
				count2++;
			}
		}
	}else if(fn.equals("delete_car_no")){	//자동차 번호 삭제
		String[] params = param.split(",");
		for(int i=0; i<params.length; i++){
			String[] value = params[i].split("//");
			
			int resultCnt = sc_db.getCarNoMappingYn(value[1]);	//value[1] : car_no
			
			if(resultCnt == 0){	//매핑된 계약이 없으면 삭제처리
				int result = sc_db.car_scrap_d(value[0]);	//value[0] : seq
				if(result==1){	count1++;	}
				
			}else{	//계약과 매핑 된 경우 
				String rent_l_cd = sc_db.getCarNoMappingInfo(value[1]);
				Hashtable ht = sc_db.getContListOne(rent_l_cd);
				if(ht.get("USE_YN").equals("N")){	//해지된 계약이면 삭제처리	(2018.01.31)		
					int result = sc_db.car_scrap_d(value[0]);	//value[0] : seq
					if(result==1){	count1++;	}	
				}else{	//해지되지 않은 계약이면 삭제불가		
					alertText += value[1]+", ";		
					count1++;	
				}
			}
		}
		if(count1 == params.length){	count2 = 1;	}
		
	}else if(fn.equals("drop_cont")){	//해지된계약-자동차번호 매핑삭제(2018.01.31)
		count1 = sc_db.dropContMapping(param);
	
	}else if(fn.equals("save_car_no_keep")){	//배정구분 일괄변경
		String[] params = param.split(",");
		int result_cnt = 0;
		for(int i=0; i<params.length; i++){
			String[] value = params[i].split("//");
			Hashtable ht = sc_db.getOneCarScrap(value[0], value[1]);	//value[0] : seq	value[1] : car_no
			String keep_yn = String.valueOf(ht.get("KEEP_YN"));
			if(keep_yn.equals("Y")){	keep_yn = "";	}else{	keep_yn = "Y"; 	}
			result_cnt += sc_db.updateOneCarScrap(value[0], value[1], keep_yn, "", "keep_yn");
		}
		if(result_cnt == params.length){			count1 = 1;		}
		
	}else if(fn.equals("save_car_no_new")){//신형번호판 일괄변경
		String[] params = param.split(",");
		int result_cnt = 0;
		for(int i = 0; i < params.length; i++) {
			String[] value = params[i].split("//");
			Hashtable ht = sc_db.getOneCarScrap(value[0], value[1]);	//value[0] : seq	value[1] : car_no
			String new_license_plate_yn = String.valueOf(ht.get("NEW_LICENSE_PLATE_YN"));
			if (new_license_plate_yn.equals("N")) {	
				new_license_plate_yn = "";
			} else {	
				new_license_plate_yn = "N";
			}
			result_cnt += sc_db.updateOneCarScrap(value[0], value[1], new_license_plate_yn, "", "new_license_plate_yn");
		}
		
		if (result_cnt == params.length) {
			count1 = 1;		
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
		var fn = '<%=fn%>';
		if(fn=="reg_new_car_no"){
			var numCount = '<%=numCount%>';
			var count1 = '<%=count1%>';
			var alertText = '<%=alertText%>';
			if(numCount == count1){
				if(!alertText==""){		alert(alertText+"\n\n해당번호는 이미 존재해서 신규생성에서 제외했습니다.");	}
				alert("정상적으로 등록되었습니다.");
			}else{	alert("등록 중 오류발생!");	}
			
		}else if(fn=="save_car_no_stat"){
			var cnt2 = '<%=cnt2%>';
			var count2 = '<%=count2%>';
			if(cnt2 != 0 && cnt2 == count2){	alert("정상적으로 저장되었습니다.");		}
			else{								alert("저장 중 오류발생!");			}
			
		}else if(fn=="delete_car_no"){
			var count2 = '<%=count2%>';
			var alertText = '<%=alertText%>';
			if(alertText !=""){	alertText += "\n\n위의 번호에는 이미 매핑된 계약이 존해해서 삭제하지 않았습니다."	;}
			if(count2==1){		alertText += "\n\n정상 삭제되었습니다.";	alert(alertText);		}
			else{				alert("삭제 중 오류발생!");	}
			
		}else if(fn=="drop_cont"){
			var count = '<%=count1%>';
			if(count==1){	alert("정상적으로 삭제되었습니다.");		}
			else{				alert("삭제 중 오류발생!");				}	
		}else if(fn=="save_car_no_keep"){
			var count = '<%=count1%>';
			if(count==1){	alert("정상적으로 수정되었습니다.");		}
			else{				alert("수정 중 오류발생!");				}	
		}else if(fn=="save_car_no_new"){
			var count = '<%=count1%>';
			if(count==1){	alert("정상적으로 수정되었습니다.");		}
			else{				alert("수정 중 오류발생!");				}	
		}
		parent.location.reload();
</script>
</body>
</html>