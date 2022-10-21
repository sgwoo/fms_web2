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
	if(fn.equals("reg_new_car_no")){	//�ű� �ڵ��� ��ȣ ���(������)
		for(int i=Integer.parseInt(car_num_first); i<=Integer.parseInt(car_num_last); i++){
			//������ ��ȣ ������ ����
			numCount = Integer.parseInt(car_num_last) - Integer.parseInt(car_num_first) + 1 ;
			
			//��ȣ ����
			String empty_num = "";	//���ڸ��� 0�ΰ�� ������ȣ4�ڸ� �����ֱ�(20181127)
			if(String.valueOf(i).length()==1){		empty_num = "000"; 	}
			else if(String.valueOf(i).length()==2){	empty_num = "00"; 	}
			else if(String.valueOf(i).length()==3){	empty_num = "0"; 	}
			
			String car_num = car_num_area + car_num_ko + empty_num + i;
			//���� ������ ��ȣ�� �̹����� ���� üũ
			Vector lists = sc_db.getNewCarNumList("","","","3","",car_num);
			if(lists.isEmpty()){	//������ ��ȣ����
				//��ȣ ����
				int result = sc_db.newCarNumReg(car_num, reg_dt, end_dt, car_ext);
				if(result == 1) {count1 ++;}
			}else{	//�̹� �����ϸ� ī��Ʈ��
				alertText += car_num + ", ";
				count1 ++;
			}
		}
	}else if(fn.equals("save_car_no_stat")){	//�������� �ϰ�����
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
	}else if(fn.equals("delete_car_no")){	//�ڵ��� ��ȣ ����
		String[] params = param.split(",");
		for(int i=0; i<params.length; i++){
			String[] value = params[i].split("//");
			
			int resultCnt = sc_db.getCarNoMappingYn(value[1]);	//value[1] : car_no
			
			if(resultCnt == 0){	//���ε� ����� ������ ����ó��
				int result = sc_db.car_scrap_d(value[0]);	//value[0] : seq
				if(result==1){	count1++;	}
				
			}else{	//���� ���� �� ��� 
				String rent_l_cd = sc_db.getCarNoMappingInfo(value[1]);
				Hashtable ht = sc_db.getContListOne(rent_l_cd);
				if(ht.get("USE_YN").equals("N")){	//������ ����̸� ����ó��	(2018.01.31)		
					int result = sc_db.car_scrap_d(value[0]);	//value[0] : seq
					if(result==1){	count1++;	}	
				}else{	//�������� ���� ����̸� �����Ұ�		
					alertText += value[1]+", ";		
					count1++;	
				}
			}
		}
		if(count1 == params.length){	count2 = 1;	}
		
	}else if(fn.equals("drop_cont")){	//�����Ȱ��-�ڵ�����ȣ ���λ���(2018.01.31)
		count1 = sc_db.dropContMapping(param);
	
	}else if(fn.equals("save_car_no_keep")){	//�������� �ϰ�����
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
		
	}else if(fn.equals("save_car_no_new")){//������ȣ�� �ϰ�����
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
				if(!alertText==""){		alert(alertText+"\n\n�ش��ȣ�� �̹� �����ؼ� �űԻ������� �����߽��ϴ�.");	}
				alert("���������� ��ϵǾ����ϴ�.");
			}else{	alert("��� �� �����߻�!");	}
			
		}else if(fn=="save_car_no_stat"){
			var cnt2 = '<%=cnt2%>';
			var count2 = '<%=count2%>';
			if(cnt2 != 0 && cnt2 == count2){	alert("���������� ����Ǿ����ϴ�.");		}
			else{								alert("���� �� �����߻�!");			}
			
		}else if(fn=="delete_car_no"){
			var count2 = '<%=count2%>';
			var alertText = '<%=alertText%>';
			if(alertText !=""){	alertText += "\n\n���� ��ȣ���� �̹� ���ε� ����� �����ؼ� �������� �ʾҽ��ϴ�."	;}
			if(count2==1){		alertText += "\n\n���� �����Ǿ����ϴ�.";	alert(alertText);		}
			else{				alert("���� �� �����߻�!");	}
			
		}else if(fn=="drop_cont"){
			var count = '<%=count1%>';
			if(count==1){	alert("���������� �����Ǿ����ϴ�.");		}
			else{				alert("���� �� �����߻�!");				}	
		}else if(fn=="save_car_no_keep"){
			var count = '<%=count1%>';
			if(count==1){	alert("���������� �����Ǿ����ϴ�.");		}
			else{				alert("���� �� �����߻�!");				}	
		}else if(fn=="save_car_no_new"){
			var count = '<%=count1%>';
			if(count==1){	alert("���������� �����Ǿ����ϴ�.");		}
			else{				alert("���� �� �����߻�!");				}	
		}
		parent.location.reload();
</script>
</body>
</html>