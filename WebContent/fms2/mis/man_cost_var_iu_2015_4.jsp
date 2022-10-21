<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String year = request.getParameter("year")==null?"":AddUtil.ChangeString(request.getParameter("year")); 
	String tm = request.getParameter("tm")==null?"":AddUtil.ChangeString(request.getParameter("tm")); 
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String gubun = request.getParameter("gubun")==null?"A":AddUtil.ChangeString(request.getParameter("gubun"));
	String cs_dt = request.getParameter("cs_dt")==null?"":AddUtil.ChangeString(request.getParameter("cs_dt")); 
	String ce_dt = request.getParameter("ce_dt")==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));

	int amt1 = request.getParameter("amt1")==null?0:AddUtil.parseDigit(request.getParameter("amt1"));  //일반정비비 한도
	int amt2 = request.getParameter("amt2")==null?0:AddUtil.parseDigit(request.getParameter("amt2"));   //사고수리비 한도
	int amt3 = request.getParameter("amt3")==null?0:AddUtil.parseDigit(request.getParameter("amt3"));
	int amt4 = request.getParameter("amt4")==null?0:AddUtil.parseDigit(request.getParameter("amt4"));
	int rent_way_1_per = request.getParameter("rent_way_1_per")==null?0:AddUtil.parseDigit(request.getParameter("rent_way_1_per"));
	int rent_way_2_per = request.getParameter("rent_way_2_per")==null?0:AddUtil.parseDigit(request.getParameter("rent_way_2_per"));
	int max_day = request.getParameter("max_day")==null?0:AddUtil.parseDigit(request.getParameter("max_day"));
	int second_per = request.getParameter("second_per")==null?0:AddUtil.parseDigit(request.getParameter("second_per"));
	int maker_dc_a = request.getParameter("maker_dc_a")==null?0:AddUtil.parseDigit(request.getParameter("maker_dc_a"));
	int commi_per = request.getParameter("commi_per")==null?0:AddUtil.parseDigit(request.getParameter("commi_per"));
	int cam_per = request.getParameter("cam_per")==null?0:AddUtil.parseDigit(request.getParameter("cam_per"));
	int a_cam_per = request.getParameter("a_cam_per")==null?0:AddUtil.parseDigit(request.getParameter("a_cam_per"));
	
	int amt1_per = request.getParameter("amt1_per")==null?0:AddUtil.parseDigit(request.getParameter("amt1_per"));
	int amt2_per = request.getParameter("amt2_per")==null?0:AddUtil.parseDigit(request.getParameter("amt2_per"));
		
	//대차	
	int cc1 = request.getParameter("cc1")==null?0:AddUtil.parseDigit(request.getParameter("cc1"));
	int cc2 = request.getParameter("cc2")==null?0:AddUtil.parseDigit(request.getParameter("cc2"));
	int cc3 = request.getParameter("cc3")==null?0:AddUtil.parseDigit(request.getParameter("cc3"));
	int cc4 = request.getParameter("cc4")==null?0:AddUtil.parseDigit(request.getParameter("cc4"));				
	int da_amt1 = request.getParameter("da_amt1")==null?0:AddUtil.parseDigit(request.getParameter("da_amt1"));
	int da_amt2 = request.getParameter("da_amt2")==null?0:AddUtil.parseDigit(request.getParameter("da_amt2"));
	int da_amt3 = request.getParameter("da_amt3")==null?0:AddUtil.parseDigit(request.getParameter("da_amt3"));
	
	int bus_cost_per = request.getParameter("bus_cost_per")==null?0:AddUtil.parseDigit(request.getParameter("bus_cost_per"));
	int mng_cost_per = request.getParameter("mng_cost_per")==null?0:AddUtil.parseDigit(request.getParameter("mng_cost_per"));
	
	int car_cnt = request.getParameter("car_cnt")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt"));
	int sale_cnt = request.getParameter("sale_cnt")==null?0:AddUtil.parseDigit(request.getParameter("sale_cnt"));	
	int base_cnt = request.getParameter("base_cnt")==null?0:AddUtil.parseDigit(request.getParameter("base_cnt"));					
				
	
	String o_cs_dt 		= request.getParameter("o_cs_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_cs_dt")); 
	String o_ce_dt 		= request.getParameter("o_ce_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_ce_dt"));	
		
	int result = 0;

//수정
	if(o_cs_dt.equals(cs_dt) && o_ce_dt.equals(ce_dt)){
		result = ac_db.updateVar(year, tm, gubun, cs_dt, ce_dt, amt1, amt2, amt3, amt4, rent_way_1_per, rent_way_2_per, max_day, second_per, maker_dc_a, commi_per, cam_per, cc1, cc2, cc3, cc4, da_amt1, da_amt2, da_amt3, amt1_per, amt2_per , bus_cost_per, mng_cost_per, car_cnt, sale_cnt, base_cnt, a_cam_per);
	
	//등록	
	}else{
		year 	= cs_dt.substring(0,4);
		tm 	= cs_dt.substring(4,6);
		
		result = ac_db.insertVar(year, tm, gubun, cs_dt, ce_dt, amt1, amt2, amt3, amt4, rent_way_1_per, rent_way_2_per, max_day, second_per, maker_dc_a, commi_per, cam_per, cc1, cc2, cc3, cc4, da_amt1, da_amt2, da_amt3, amt1_per, amt2_per , bus_cost_per, mng_cost_per, car_cnt, sale_cnt, base_cnt, a_cam_per);
		
	//	System.out.println("year=" + year);
	}


%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
수정되었습니다.
변경된 변수가 반영된 캠페인을 마감합니다. 기다려 주십시오.
<script language="JavaScript">

         modalPop();
    
	function modalPop(){ 
	
//		 var objectName = new Object(); // object 선언 modal의 이름이 된다.
 // 		 objectName.message = "마감";  // 선언할 수 있다.
    
//	    	var site = "http://211.174.180.197/acar/admin/man_cost_j_campaign_null.jsp?gubun=4";    
 //		var style ="dialogWidth:5px;dialogHeight:5px"; // 사이즈등 style을 선언
  //		var vReturn = window.showModalDialog(site, objectName ,style ); // modal 실행 window.showModalDialog 포인트!!
 
		var site = "http://cms.amazoncar.co.kr:8080/acar/admin/man_cost_j_campaign_null.jsp?gubun=A";    			
		var popOptions = "dialogWidth: 5px; dialogHeight: 5px; center: yes; resizable: yes; status: no; scroll: no;"; 		
		var vReturn = window.showModalDialog(site, window,  popOptions ); 	
			
		//강제창 종료
		window.close();	
	 	
	//	alert(vReturn);
	//	if (vReturn == 'ok'){
	//		alert("aaa");
	//		// (모달창에서 버튼 이벤트 실행 또는 닫기 후)모달창이 닫혔을 때 부모창에서 실행 할 함수			
	//	//	opener.parent.location.reload();  			
	//		return;
	//		
	//	}else{
	//		alert("bbb");
	//		return;
	//		
	//	}
		
		return vReturn;
	} 

//	 var objectName = new Object(); // object 선언 modal의 이름이 된다.
    //	 objectName.message = "마감";  // 선언할 수 있다.
 
    //	var site = "http://211.174.180.197/acar/admin/man_cost_j_campaign_null.jsp?gubun=1";    
 //	var style ="dialogWidth:255px;dialogHeight:250px"; // 사이즈등 style을 선언
    //	window.showModalDialog(site, objectName ,style ); // modal 실행 window.showModalDialog 포인트!!
 	
 
    	// modal 에 넘겨줬던 값을 다시 부모창에 받아 들임    
    //	document.getElementById("test1").value = objectName.message;

</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
