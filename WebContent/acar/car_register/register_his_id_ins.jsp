<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*,acar.common.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	//�ڵ�����ȣ���� ����ϱ� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();

  //�����������
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
  
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Reg(){
		fm = document.form1;
		if(fm.car_mng_id.value==''){	alert("����� ���� ������ּ���!"); return; }
		if(fm.cha_dt.value==''){	alert("�������ڸ� �Է����ּ���!"); return; }
		if(fm.cha_car_no.value==''){	alert("����� ������ȣ�� �Է����ּ���!"); return; }				
		if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '1' && fm.car_ext.value == ''){ //��뺻��������
			alert("����Ǵ� ��뺻������ �����Ͻʽÿ�."); return;
		}
		if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '2' && fm.car_use.value == ''){ //�뵵����
			alert("����Ǵ� �뵵�� �����Ͻʽÿ�."); return;
		}
		
		if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '1'){ //��뺻��������
			if(fm.car_ext_old.value == fm.car_ext.value){
				alert("��뺻������ �����ϴ�. Ȯ���Ͻʽÿ�."); return;			
			}
			fm.cha_cau_sub.value = fm.cha_cau_sub.value + '('+ fm.car_ext_old.options[fm.car_ext_old.selectedIndex].text+'->'+fm.car_ext.options[fm.car_ext.selectedIndex].text + ')';
		}
		
		if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '2'){ //�뵵����
			if(fm.car_use_old.value == fm.car_use.value){
				alert("�뵵�� �����ϴ�. Ȯ���Ͻʽÿ�."); return;			
			}
			
			if(fm.maint_st_dt.value==''){	alert("�˻���ȿ�Ⱓ�� �Է����ּ���!"); return; }
			if(fm.maint_end_dt.value==''){	alert("�˻���ȿ�Ⱓ�� �Է����ּ���!"); return; }	
			
			if ( fm.car_use.value == '1' ) { //������
				if(fm.cha_car_no.value.indexOf("GJ") != -1 || fm.cha_car_no.value.indexOf("gj") != -1 || fm.cha_car_no.value.indexOf("GH") != -1 || fm.cha_car_no.value.indexOf("gh") != -1 || fm.cha_car_no.value.indexOf("GA") != -1 || fm.cha_car_no.value.indexOf("ga") != -1){
					alert("�ڵ���������ȣ�� Ȯ���Ͻʽÿ�. �߸� �ԷµǾ� �ֽ��ϴ�."); return; 
				}
				
				if(fm.cha_car_no.value.indexOf("��") == -1 && fm.cha_car_no.value.indexOf("��") == -1 && fm.cha_car_no.value.indexOf("ȣ") == -1  ){	alert("�ڵ���������ȣ�� Ȯ���Ͻʽÿ�."); return; }
				
				if(fm.car_end_dt.value==""){		alert("���ɸ������� �Է��Ͻʽÿ�."); 	 return;  }	
			
				
			}
			
			if ( fm.car_use.value == '2' ) { //�ڰ���
					if(fm.cha_car_no.value.indexOf("GJ") != -1 || fm.cha_car_no.value.indexOf("gj") != -1 || fm.cha_car_no.value.indexOf("GH") != -1 || fm.cha_car_no.value.indexOf("gh") != -1 || fm.cha_car_no.value.indexOf("GA") != -1 || fm.cha_car_no.value.indexOf("ga") != -1){
					alert("�ڵ���������ȣ�� Ȯ���Ͻʽÿ�.  �߸� �ԷµǾ� �ֽ��ϴ�."); 
					return; 
				}
			
				if(fm.cha_car_no.value.indexOf("��") != -1 || fm.cha_car_no.value.indexOf("ȣ") != -1 || fm.cha_car_no.value.indexOf("��") != -1 ){
					alert("�ڵ���������ȣ�� Ȯ���Ͻʽÿ�."); 
					return; 
				}	
				
				if(fm.car_end_dt.value !=''){		alert("���ɸ������� �������ֽʽÿ�."); 	 return;  }	
						
							
			}
							
			fm.cha_cau_sub.value = fm.cha_cau_sub.value + '('+ fm.car_use_old.options[fm.car_use_old.selectedIndex].text+'->'+fm.car_use.options[fm.car_use.selectedIndex].text + ')';
				
		}
		
		//if(fm.filename2.value != ''){
		//	if(fm.filename2.value.indexOf('jpg') == -1 && fm.filename2.value.indexOf('JPG') == -1){		alert('JPG������ �ƴմϴ�.');						return;		}		
		//}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		fm.action = "register_his_id_ins_a.jsp";
		//fm.action = "https://fms3.amazoncar.co.kr/acar/upload/car_register_register_his_id_ins_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.form1;
		if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '1'){ //��뺻��������
			td_cau1.style.display	= '';
			td_cau2.style.display 	= '';
			td_cau3.style.display	= 'none';
			td_cau4.style.display	= 'none';
		}else if(fm.cha_cau.options[fm.cha_cau.selectedIndex].value == '2'){ //�뵵����
			td_cau1.style.display	= '';
			td_cau2.style.display 	= 'none';
			td_cau3.style.display	= '';
			td_cau4.style.display	= '';
		}else{
			td_cau1.style.display	= '';
			td_cau2.style.display 	= 'none';
			td_cau3.style.display	= 'none';
			td_cau4.style.display	= 'none';
		}
	}	
//-->	
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><a href="javascript:Reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a></div></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=7%>����</td>
                    <td class=title width=12%>��������</td>
                    <td class=title width=15%>������ȣ</td>
                    <td class=title width=27%>����</td>
                    <td class=title width=39%>�󼼳���</td>
                    <!--<td class=title width=24%>�������ĵ</td>-->
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td align=center><input type="text" name="cha_dt" size="12" class=text maxlength="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align=center><input type="text" name="cha_car_no" size="10" class=text maxlength="15" style='IME-MODE: active'></td>
                    <td align=center> <select name="cha_cau" style="width:125px" onChange='javascript:cng_input()'>
                      <option value="">����</option>
                      <%if(ch_r.length == 0){%>
                      <option value="5" selected>�űԵ��</option>
                      <%}%>
                      <option value="1">��뺻���� ����</option>
                      <option value="2">�뵵����</option>
                      <option value="3">��Ÿ</option>
                      <option value="4">����</option>
                    </select></td>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_cau2' style='display:none'>
                              		&nbsp;<select name="car_ext_old" disabled>
                   	    <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(cr_bean.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                              		</select>
                				    ->
                				    <select name="car_ext">
                                      <option value="">����</option>
                   	    <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        <%}%>
                                    </select></td>
                                <td id='td_cau3' style='display:none'>
                              		&nbsp;<select name="car_use_old" disabled>
                                	  <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>������</option>
                                	  <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>�ڰ���</option>
                             		</select>
                					->				  
                				    <select name="car_use">
                                      <option value="">����</option>
                                      <option value="1">������</option>
                                      <option value="2">�ڰ���</option>
                                    </select></td>
                                 <td id='td_cau1' style="display:''">
            				     &nbsp;<input type="text" name="cha_cau_sub" size="20" class=text></td>	
                            </tr>
                            <tr>
                           	  <td id='td_cau4' style='display:none' colspan=2>
                           	        �˻���ȿ�Ⱓ:&nbsp;<input type="text" name="maint_st_dt" value="<%=cr_bean.getMaint_st_dt()%>" size="10" class=text>
                     							 ~ 
                      							 <input type="text" name="maint_end_dt" value="<%=cr_bean.getMaint_end_dt()%>" size="10" class=text>
                      							 <br>
                                    ���ɸ�����&nbsp;&nbsp;&nbsp;:&nbsp;<input type="text" name="car_end_dt" value="<%=cr_bean.getCar_end_dt()%>" size="10" class=text>
                               
						      </td>		                                                   
                            </tr>
                                                        
                        </table>
                    </td>
                    <!--<td>&nbsp;<input type="file" name="filename2" size="15"></td>-->
                </tr>
            </table>
        </td>
    </tr>
    <!--
    <tr>
        <td><font color=red>* ��ĵ������ jpg ���Ϸ� ���ּ���.</font></td>
    </tr>	
    -->
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</html>
