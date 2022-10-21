<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "01");	
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	String sub_c_id 	= request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	String off_id 	= request.getParameter("off_id")  ==null?""   :request.getParameter("off_id");
	String off_nm 	= request.getParameter("off_nm")  ==null?""   :request.getParameter("off_nm");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	String ven_code = "";
	String ven_name = "";
	
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
		
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	
	
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
		
//��������� �˻��ϱ�
	function find_cls_search(){
		var fm = document.form1;
		if(fm.n_ven_code.value == '') { alert('���Ӿ�ü�� Ȯ���Ͻʽÿ�.'); return; }
		if(fm.bank_cd.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
		if(fm.bank_nm.value == ""){ alert("�����ָ� �Է��Ͻʽÿ�."); return; }			
		if(fm.bank_no.value == ""){ alert("���¹�ȣ�� �Է��Ͻʽÿ�."); return; }				
		if(fm.re_bank_cd.value == ""){ alert("������ �����Ͻʽÿ�."); return; }		
		if(fm.re_bank_nm.value == ""){ alert("�����ָ� �Է��Ͻʽÿ�."); return; }			
		if(fm.re_bank_no.value == ""){ alert("���¹�ȣ�� �Է��Ͻʽÿ�."); return; }		
		window.open("find_cls_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&n_ven_code="+fm.n_ven_code.value, "SEARCH_FINE", "left=50, top=50, width=1080, height=700, scrollbars=no");
	}		
	
	//���Ӿ�ü ��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.n_ven_name.value != ''){	fm.t_wd.value = fm.n_ven_name.value;		}
		else{ 							alert('��ȸ�� �ŷ�ó���� �Է��Ͻʽÿ�.'); 	fm.n_ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=700, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
				
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">

<form  name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>	

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > Ź�۰��� > <span class=style5>���(�Ÿ�)Ź���Ƿڵ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
  
    <tr>
        <td class=line2></td>
    </tr>
    
     <tr>
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				
					<tr>
		                    <td width="13%" class=title>��������</td>
		                    <td colspan=6>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>���Ӿ�ü��</td>
	                    <td colspan=4>&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* �׿����ڵ� : &nbsp;	        
						<input type="text" readonly name="n_ven_code" value="<%=ven_code%>" class='whitetext' >
			      		<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;		
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> </td>				
		
	                    <td width="13%" class='title'>�߽ɼ�����(vat����)</td>
	                    <td>&nbsp;ȸ���ݾ��� <input type="text" name="re_rate" value="25" size="3" class=num>%</td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>�μ���</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_dept" value="" size="25" class=text></td>
	                    <td width="10%" class='title' rowspan=2>�����</td>
	                    <td width="10%" class='title'>����</td>
	                    <td><input type="text" name="re_nm" value="" size="25" class=text></td>	             
	                   <td width="13%" class='title'>fax</td>
	                    <td><input type="text" name="re_fax" value="" size="25" class=text></td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>��ǥ��ȭ</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_tel" value="" size="25" class=text></td>	            
	                    <td width="10%" class='title'>����ó</td>
	                    <td><input type="text" name="re_phone" value="" size="25" class=text></td>	             
	                   <td width="13%" class='title'>�̸���</td>
	                    <td><input type="text" name="re_mail" value="" size="25" class=text></td>	             
	                </tr>     
    	      </table>
    	     </td>
    	 </tr>
    	
    	<tr></tr><tr></tr>
        <tr> 
	 	  <td> 
	    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	          <tr> 
	 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�����</span></td>
	 	 	  </tr>
	 	 	  <tr>
	      		 <td class=line2></td>
	   		  </tr>
	 	 	  <tr>
	 	 	  	 <td class='line'>  
			    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
			    	
			    	 <tr>
			                    <td width="50%" class=title colspan=3>ä��ȸ���� �Աݰ���</td>
			                    <td width="50%" class=title colspan=3>�߽ɼ����� ���ް���</td>		                
		                </tr>
		                 <tr>
		                    <td width="15%" class=title>�����</td>
		                     <td width="15%" class=title>������</td>
		                     <td width="20%" class=title>���¹�ȣ</td>
		                      <td width="15%" class=title>�����</td>
		                      <td width="15%" class=title>������</td>
		                      <td width="20%" class=title>���¹�ȣ</td>	            
		                </tr>
		                   <tr>
		                      <td >&nbsp; <select name="bank_cd" style="width:135">
	                           <option value="026">��������</option> 
				      </select></td>	   	           
		                     <td width="15%">&nbsp;<input type="text" name="bank_nm" value="(��)�Ƹ���ī" size="25" class=text></td>
		                     <td width="20%">&nbsp;<input type="text" name="bank_no" value="140-004-023871" size="25" class=text></td>
		                    <td >&nbsp; <select name="re_bank_cd" style="width:135">
	                            <option value="026">��������</option> 
				      </select></td>	             
		                      <td width="15%">&nbsp;<input type="text" name="re_bank_nm" value="(��)�Ƹ���ī" size="25" class=text></td>
		                      <td width="20%">&nbsp;<input type="text" name="re_bank_no" value="140-004-023871" size="25" class=text></td>	            
		                </tr>        
		              
		    	 </table>
		      </td>  
		     <tr>       
       	</table>
      </td>	 
    </tr>	   
   
    <tr>
        <td class=h></td>
    </tr>		
	
	 <tr> 
        <td><a href="javascript:find_cls_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>		
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
var fm = document.form1;	
//-->
</script>
</body>
</html>