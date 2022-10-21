<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="acar.util.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String search_text = request.getParameter("search_text")==null?"":request.getParameter("search_text");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String  result ="";
	
	Hashtable ht = new Hashtable();
	String rent_mng_id ="";
	
	if(!search_text.equals("")){ //�˻���ư ��������
		search_text = search_text.replaceAll(" ","");
		InsDatabase ai_db = InsDatabase.getInstance();
		InsComDatabase ic_db = InsComDatabase.getInstance();
		
		ht = ai_db.getClientInsInfo2(s_kd, search_text);

		rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
		
		if(!rent_mng_id.equals("")){ //����輭 ��� ��û ��ư ��������
			String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
			String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
			String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
			
			String changeGubun = request.getParameter("changeGubun")==null?"":request.getParameter("changeGubun");
			//������
			String change1 = request.getParameter("change1")==null?"":request.getParameter("change1");
			//������
			String change2 = request.getParameter("change2")==null?"":request.getParameter("change2");
			
			//������
			String firm_nm1 = request.getParameter("firm_nm1")==null?"":request.getParameter("firm_nm1");
			String enp_no1 = request.getParameter("enp_no2")==null?"":request.getParameter("enp_no1");
			String age_scp1 = request.getParameter("age_scp1")==null?"":request.getParameter("age_scp1");
			String gcp_kd1 = request.getParameter("gcp_kd1")==null?"":request.getParameter("gcp_kd1");
			String com_emp_yn1 = request.getParameter("com_emp_yn1")==null?"":request.getParameter("com_emp_yn1");
			String ins_start_dt1 = request.getParameter("ins_start_dt1")==null?"":request.getParameter("ins_start_dt1");
			String legal_yn1 = request.getParameter("legal_yn1")==null?"":request.getParameter("legal_yn1");
			
			//������
			String firm_nm2 = request.getParameter("firm_nm2")==null?"":request.getParameter("firm_nm2");
			String enp_no2 = request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2");
			String age_scp2 = request.getParameter("age_scp2")==null?"":request.getParameter("age_scp2");
			String gcp_kd2 = request.getParameter("gcp_kd2")==null?"":request.getParameter("gcp_kd2");
			String com_emp_yn2 = request.getParameter("com_emp_yn2")==null?"":request.getParameter("com_emp_yn2");
			String ins_start_dt2 = request.getParameter("ins_start_dt2")==null?"":request.getParameter("ins_start_dt2");
			String legal_yn2 = request.getParameter("legal_yn2")==null?"":request.getParameter("legal_yn2");
			
			
			InsurExcelBean ins = new InsurExcelBean();
			
			int count=1;	
			String curTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
			String reg_code  = "BASE"+Long.toString(System.currentTimeMillis());
			
			
			ins.setReg_code		(reg_code);
			ins.setSeq			(count);
			ins.setReg_id		(ck_acar_id);//��Ű���� ������ user_id��
			ins.setValue01		("�߰� ��ϰ�");
			ins.setValue02		(rent_mng_id);	
			ins.setValue03		(rent_l_cd);
			ins.setValue05		(curTime);
			
			String value06 ="";
			if(changeGubun.equals("1")){
				value06 = "��������������";
			}else if(changeGubun.equals("2")){
				value06 = "���ɹ���";
			}else if(changeGubun.equals("3")){
				value06 = "�빰���";
			}else if(changeGubun.equals("4")){
				value06 = "������";
			}else if(changeGubun.equals("5")){
				value06 = "��Ÿ��ġ";
			}else if(changeGubun.equals("6")){
				value06 = "�������������";
			}else{
				value06 = "";
			}
			
		 	ins.setValue06		(value06);
		 	
		 	if(!changeGubun.equals("4") && !changeGubun.equals("")){ //������(����,�빰,������)
				ins.setValue07		(change1);
				ins.setValue08		(change2); 
		 		
		 	}else{ //�������ϰ��
				ins.setValue07		(firm_nm1+"/"+enp_no1 +"/"+ age_scp1 +"/"+ gcp_kd1 +"/"+ com_emp_yn1 +"/"+ ins_start_dt1 ); 
				ins.setValue08		(firm_nm2+"/"+enp_no2 +"/"+ age_scp2 +"/"+ gcp_kd2 +"/"+ com_emp_yn2 +"/"+ ins_start_dt2 ); 
		 		
		 	}
			ins.setValue09		(String.valueOf(ht.get("RENT_MNG_ID")));
			ins.setValue10		(String.valueOf(ht.get("RENT_L_CD")));
			ins.setValue11		(String.valueOf(ht.get("CAR_MNG_ID")));
			ins.setValue12		(String.valueOf(ht.get("INS_ST")));
			
			if(changeGubun.equals("1")){
				ins.setValue14		(change2);
			}

			//validation üũ
			if(!changeGubun.equals("4") && !changeGubun.equals("")){ //������(����,�빰,������)
		 		if(change1.equals("") && change2.equals("")){
		 			result = "���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
				
		 	}else{ //�������ϰ��
		 		if(firm_nm1.equals("") && firm_nm2.equals("")){
		 			result = "��ȣ�� ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
		 		if(enp_no1.equals("") && enp_no2.equals("")){
		 			result = "����ڹ�ȣ ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
		 		if(age_scp1.equals("") && age_scp2.equals("")){
		 			result = "���ɹ��� ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
		 		if(gcp_kd1.equals("") && gcp_kd2.equals("")){
		 			result = "�빰 ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
		 		if(com_emp_yn1.equals("") && com_emp_yn2.equals("")){
		 			result = "���������Կ��� ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
		 		if(ins_start_dt1.equals("") && ins_start_dt2.equals("")){
		 			result = "��������� ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		}
/* 		 		if(legal_yn1.equals("") && legal_yn2.equals("")){
		 			result = "������������� ���� ���� ���� ������ �����ڿ��� ���� �ٶ��ϴ�";
		 		} */
		 	}
			
			if(result.equals("")){
				if(!ai_db.insertInsExcel2(ins)){
					result="ins_excel ��Ͻ� ������ �߻��Ͽ����ϴ�.";
				}else{
					boolean flag =  ic_db.call_sp_ins_cng_req_com(reg_code,count);
					%>
						alert('<%=flag%>');
					<%
					if(!flag){
						result = "ins_excel_com ��Ͻ� ������ �߻��߽��ϴ�.";
					}else{
						result = "success";
					}
				}	
			}
			
		}
		
	}
	
%>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<script>
$(document).ready(function(){
	
	//�ݿ� ���
	var rent_mng_id= '<%=rent_mng_id%>';
	var result = '<%=result%>';
	if(rent_mng_id != ""){
		if(result != 'success') 
			alert(result);
		else 
			alert("����� �Ϸ�Ǿ����ϴ�.");
			window.close();
	}
	
	//�ݿ���ư Ŭ����
    $("#saveBtn").bind("click", function(){
    	var flag = 0;
    	if($("#changeGubun").val() == ""){
    		alert("��� ������ �Է����ֽñ� �ٶ��ϴ�");
    		
    	}else if($("#changeGubun").val() == 4){
    			if($('#changeArea').find($('.firm_nm2')).val() ==""){
        			alert("��ȣ�� �Է����ֽñ� �ٶ��ϴ�");	
    			}else if($('#changeArea').find($('.enp_no2')).val() ==""){
        			alert("����ڹ�ȣ�� �Է����ֽñ� �ٶ��ϴ�");	
        		}else if($('#changeArea').find($('.age_scp2')).val() ==""){
        			alert("���ɹ����� �Է����ֽñ� �ٶ��ϴ�");	
        		}else if($('#changeArea').find($('.gcp_kd2')).val() ==""){
        			alert("�빰�� �Է����ֽñ� �ٶ��ϴ�");	
        		}else if($('#changeArea').find($('.com_emp_yn2')).val() ==""){
        			alert("���������Կ����� �Է����ֽñ� �ٶ��ϴ�");	
        		}else if($('#changeArea').find($('.ins_start_dt2')).val() ==""){
        			alert("����������� �Է����ֽñ� �ٶ��ϴ�");	
        		}else{
    				flag = 1;
        		}
    		
    	}else{
    		if($('#changeArea').find($('.change2')).val() ==""){
    			alert("���� �� ������ �Է����ֽñ� �ٶ��ϴ�");	
    		}else{
    			flag=1;
    		}
    	}
    	
    	if(flag == 1){
	    	var fm = document.form1;
			fm.action = "ins_com_add.jsp";
			var popup1 = window.open('','add_popup','left=200, top=250, width=800, height=500, scrollbars=yes'); 
			fm.submit();
    	}
    });
    
	//�˻���ư Ŭ����
    $("#search").bind("click", function(){
    	if($("#search_text").val() != ""){
    		$("#rent_mng_id").remove();
	    	var fm = document.form1;
			//fm.target = "d_content";
			
			fm.action = "ins_com_add.jsp";
			var popup1 = window.open('','add_popup','left=200, top=250, width=800, height=500, scrollbars=yes'); 
			fm.submit();
    	}else{
    		alert("������ȣ�� �Է����ֽñ� �ٶ��ϴ�");	
    	}   	
    });
    
	//�˻���ư Ŭ�� �� �ش������� ���� ������
	var h2='<%=ht%>';
	if( h2 != '{}' ){
		$('#selectArea').children($('#table1')).css("display","block");
	}
    
    //��౸�� �����
    $('#changeGubun').bind("change", function(){
    	if(this.value == ""){
    		$('#changeArea').children($('#table2')).remove();
    		$('#changeArea').children($('#table3')).remove();
    		
    	}else if(this.value == 4){
    		$('#changeArea').children($('#table2')).remove();
    		$('#changeArea').append($('#table3').clone());
    		$('#changeArea').children($('#table3')).css("display","block");
    		
    		$('#changeArea').find($('.firm_nm1')).val('<%=String.valueOf(ht.get("FIRM_EMP_NM"))%>');
    		$('#changeArea').find($('.enp_no1')).val('<%=String.valueOf(ht.get("ENP_NO"))%>');
    		$('#changeArea').find($('.age_scp1')).val('<%=String.valueOf(ht.get("AGE_SCP"))%>');
    		$('#changeArea').find($('.gcp_kd1')).val('<%=String.valueOf(ht.get("GCP_KD"))%>');
    		$('#changeArea').find($('.com_emp_yn1')).val('<%=String.valueOf(ht.get("COM_EMP_YN"))%>');
    		$('#changeArea').find($('.ins_start_dt1')).val('<%=String.valueOf(ht.get("INS_START_DT"))%>');
    	<%-- 	$('#changeArea').find($('.legal_yn1')).val('<%=String.valueOf(ht.get("LEGAL_YN"))%>'); --%>
    		
    	}else{
    		$('#changeArea').children($('#table3')).remove();
    		$('#changeArea').append($('#table2').clone());
    		$('#changeArea').children($('#table2')).css("display","block");
    		
    		if(this.value == 1){
    			$('#changeArea').find($('.change1')).val('<%=String.valueOf(ht.get("COM_EMP_YN"))%>');
    		}else if(this.value == 2){
    			$('#changeArea').find($('.change1')).val('<%=String.valueOf(ht.get("AGE_SCP"))%>');
    		}else if(this.value == 3){
    			$('#changeArea').find($('.change1')).val('<%=String.valueOf(ht.get("GCP_KD"))%>');
    		}else if(this.value == 5){
    			$('#changeArea').find($('.change1')).val('<%=String.valueOf(ht.get("OTHERS_DEVICE"))%>');
    		}else if(this.value == 6){
    			$('#changeArea').find($('.change1')).val('<%=String.valueOf(ht.get("LEGAL_YN"))%>');
    		}
    	}
    	
    });

});
</script>
<style>
     .title{	background-color: #349BD5;
     			color:white;font-size:9pt;
     			text-align:center;
     			width:100px;height:25px;
     		}
     .title2{	background-color: FFCCCC;
     			color:#464e7c;font-size:9pt;
     			text-align:center;font-weight:bold;
     			width:100px;height:25px;
     		}
     input[type=text]{width:200px;height:25px}
     
     #saveBtn{   background-color: #6d758c;
				font-size: 12px;cursor: pointer;
				border-radius: 2px;color: #fff;
				border: 0; outline: 0;
				padding: 5px 8px; margin: 3px;
				width:200px;height:25px;
				
			}
	  #search{   background-color: #6d758c;
				font-size: 12px;cursor: pointer;
				border-radius: 2px;color: #fff;
				border: 0; outline: 0;
				padding: 5px 8px; margin: 3px;
				width:100px;height:25px;
				
			}
		.style1 {color: #666666}
		.style2 {color: #515150; font-weight: bold;}
		.style3 {color: #b3b3b3; font-size: 11px;}
		.style4 {color: #737373; font-size: 11px;}
		.style5 {color: #ef620c; font-weight: bold;}
		.style6 {color: #4ca8c2; font-weight: bold;}
		.style7 {color: #666666; font-size: 11px;}
</style>

<body>
<div class="navigation" style="margin-bottom:30px;">
	<span class=style1>������� ></span><span class=style1>�輭��Ȳ ></span><span class=style5>�輭�߰�</span>
</div>
<form id="form1" name="form1" method="post" target="add_popup">
<input type="hidden" name="rent_mng_id" id="rent_mng_id" value="<%=String.valueOf(ht.get("RENT_MNG_ID"))%>" />
<input type="hidden" name="rent_l_cd" id="rent_l_cd" value="<%=String.valueOf(ht.get("RENT_L_CD"))%>" />
<input type="hidden" name="car_mng_id" id="car_mng_id" value="<%=String.valueOf(ht.get("CAR_MNG_ID"))%>" />
<input type="hidden" name="ins_st" id="ins_st" value="<%=String.valueOf(ht.get("INS_ST"))%>" />
<div style="width:610px;">
<table border="0" cellspacing="1" cellpadding='0' id="table">
  	<tr>
   	 <td class=title>
   	 	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>������ȣ</option>
		<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>���ǹ�ȣ</option>
	</select>
   	 
   	 </td>
       <td>
			<input type='text' id='search_text' name='search_text' value='<%=search_text%>'>	
       </td>  
       <td>
			<input type='button' name='' value='�˻�' colspan=2 id="search">	
       </td>  
    </tr>	
		
</table>
	<div id="selectArea" style="margin-top:20px;">
	<table border="0" cellspacing="1" cellpadding='0' id="table1" style="display:none; margin-top:30px;">
	 <tr>
    	<td class=title>��౸��</td>
     	<td  colspan="4">
	        <select name="changeGubun" id="changeGubun" style="width:200px;height:25px;">
				<option value=''>����</option>
				<option value='1'>��������������</option>
				<option value='2'>���ɹ���</option>
				<option value='3'>�빰���</option>
				<option value='4'>������</option>
				<option value='5'>��Ÿ��ġ</option>
				<option value='6'>�������������</option>
	        </select>
        </td>
   	</tr>
	</table>
	</div>
	<div id="changeArea" style="margin-top:20px;">
	</div>

	<div id="buttonWrap" style="text-align: center; margin-top:50px; ">
		<input type="button" value="����輭 ��� ��û" id="saveBtn">
	</div>

</div>
</form>



<table border="0" cellspacing="1" cellpadding='0' id="table2" style="display:none; ">
	
	 <tr>
    	<td class=title>������</td>
       <td>
			<input type='text' name='change1' value='' class="change1">	
       </td>  
       <td class=title2>������</td>
       <td>
		<input type='text' name='change2' value='' class="change2">	
      </td>  
    </tr>
</table>	



<table border="0" cellspacing="1" cellpadding='0' id="table3" style="display:none">
	<tr>
		<td class=title colspan=2>������</td>
		<td class=title2 colspan=2>������</td>
	</tr>
	
	<tr>
		<td class=title>��ȣ</td>
		<td>
			<input type='text' name='firm_nm1' value='' class="firm_nm1" >	
		</td>  
		<td class=title2>��ȣ</td>
		<td>
			<input type='text' name='firm_nm2' value='' class="firm_nm2">	
		</td>  
	</tr>
	<tr>
		<td class=title>����ڹ�ȣ</td>
		<td>
			<input type='text' name='enp_no1' value='' class="enp_no1">	
		</td>  
		<td class=title2>����ڹ�ȣ</td>
		<td>
			<input type='text' name='enp_no2' value='' class="enp_no2">	
		</td>  
	</tr>
	<tr>
		<td class=title>���ɹ���</td>
		<td>
			<input type='text' name='age_scp1' value='' class="age_scp1">	
		</td>  
		<td class=title2>���ɹ���</td>
		<td>
			<input type='text' name='age_scp2' value='' class="age_scp2">	
		</td>  
	</tr>
	<tr>
		<td class=title>�빰</td>
		<td>
			<input type='text' name='gcp_kd1' value='' class="gcp_kd1">		
		</td>  
		<td class=title2>�빰</td>
		<td>
			<input type='text' name='gcp_kd2' value='' class="gcp_kd2">	
		</td>  
	</tr>
	<tr>
		<td class=title>���������Կ���</td>
		<td>
			<input type='text' name='com_emp_yn1' value=''  class="com_emp_yn1">		
		</td>  
		<td class=title2>���������Կ���</td>
		<td>
			<input type='text' name='com_emp_yn2' value=''  class="com_emp_yn2">		
		</td>  
	</tr>
	<tr> 
		<td class=title>���������</td>
		<td>
			<input type='text' name='ins_start_dt1' value=''  class="ins_start_dt1">		
		</td>  
		<td class=title2>���������</td>
		<td>
			<input type='text' name='ins_start_dt2' value='' class="ins_start_dt2">		
		</td>  
	</tr>
</table>

</body>

