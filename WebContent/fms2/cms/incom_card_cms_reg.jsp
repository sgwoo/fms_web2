<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int count = 0;

	//jip_cms ���̺��� �Աݹݿ��� ����Ƿ��� ��ȸ�ϱ�
	Vector vt2 = ad_db.getACardJipCmsDate();
	int vt_size2 = vt2.size();
//	out.println("vt_size2=" + vt_size2);
		
	
	//��ݰǼ�		
//	String e = StringCrypto.encrypt("SSN", "1288147957");
//	out.println(e);
//	String d = StringCrypto.decrypt("SSN", e);
//	out.println(d);
 				
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//����
	function incomCardCms(){
		var theForm = document.form1;
		
		
		if(theForm.cms_cnt.value != '1'){ alert("����Ƿ����ڿ����Դϴ�.  ����ǿ� �����ϼ���!"); return; }
		if(theForm.ama_id.value == ''){ alert("�ŷ���ID�� Ȯ���ϼ���!"); return; }
	//	if(theForm.incom_dt.value == ''){ alert("�������ڸ� Ȯ���ϼ���!"); return; }
	//	if(theForm.incom_amt.value == ''){ alert("���αݾ��� Ȯ���ϼ���!"); return; }
	//	if(theForm.v_gubun[0].checked == false && theForm.v_gubun[1].checked == false ) 
	//		{ alert('������ �����Ͻʽÿ�.'); return;}	
				
		if(confirm('����ó���Ͻðڽ��ϱ�?'))
		{			
			theForm.target = 'i_no';
			theForm.action='incom_card_cms_reg_a.jsp';
			theForm.submit();
		}
	}

		
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
.style8 {color: #0054ff; font-weight: bold;}
.style9 {color: #ff0000; font-weight: bold;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<center>
<form  name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="cms_cnt" value="<%=vt_size2 %>">

<table border=0 cellspacing=0 cellpadding=0 width=900>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �繫ȸ�� > CMS > <span class=style5>ī�� CMS ����ó��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style8>ī�� CMS ���ݿ���ó��</span>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=900>
                <tr>			    	
                    <td class=title width=200>�����Ƿ�����</td>	
                    <td width='600' >&nbsp;
	              <select name="adate">
				    <option value="">����</option>
	<%		for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);%>
	                <option value="<%=ht.get("ADATE")%>"  ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ADATE")))%></option>
	<%		}%>
	              </select>	
			  </td>		    	
              
	      </tr>
	        <tr>
	             <td class=title width=200>����ڵ�</td>			    	
                       <td width='600' >&nbsp;
	              <select name="ama_id">
				    <option value="">����</option>
				    <option value="30042445">30042445</option>             
			                                        
	              </select>	
			  </td>		
	  		 </tr>	 
             </table>
            </td>
         </tr>
         <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><font color=red>* ó���ð��� �ҿ�Ǵ� �۾��Դϴ�.  </font></td>
    </tr>
    <% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  	
   <tr>
	<td align='right'><a href="javascript:incomCardCms()"><img src=/acar/images/center/button_reg.gif border=0></a></td>
  </tr>
  <% } %>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>