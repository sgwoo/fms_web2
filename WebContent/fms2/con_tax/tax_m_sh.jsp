<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'tax_m_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function cng_dt_input(){
		var fm = document.form1;
		
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '1'){ 			//�⵵��
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '2'){ 			//�б⺰
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= '';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ 			//����
			tr_dt1.style.display		= '';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= '';
			tr_dt4.style.display 		= 'none';		
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ 			//�Ⱓ
			tr_dt1.style.display		= 'none';
			tr_dt2.style.display		= 'none';
			tr_dt3.style.display	 	= 'none';
			tr_dt4.style.display 		= '';		
		}				
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���������� > <span class=style5>
						�����Һ�</span></span></td>
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
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td class="title">��ȸ����</td>
                <td colspan="3">
				  <table border="0" cellspacing="1" cellpadding='0'>
                    <tr>
				  	  <td width='100'>&nbsp;
				  	    <select name='gubun1'>
                  	      <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>�����߻���</option>
                  	      <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>��������</option>
                  	      <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>ȸ��ó����</option>						  
                  	    </select>	</td>
				  	  <td width='100'>&nbsp;	
				  	    <select name='gubun2' onChange='javascript:cng_dt_input()'>
                  	      <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>�⵵��</option>
                  	      <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>�б⺰</option>
                  	      <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>����</option>										
                  	      <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>�Ⱓ</option>					
                  	    </select></td>
				  	  <td width='100' id=tr_dt1 style="display:<%if(!gubun2.equals("4")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun5" >
        			  	  <option value=""  <%if(gubun5.equals("")){%> selected <%}%>>��ü</option>						
          				  <% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
          				  <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun5)){%> selected <%}%>><%=i%>�⵵</option>
         				  <%}%>
        				</select></td>
				  	  <td width='100' id=tr_dt2 style="display:<%if(gubun2.equals("2")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun6">
        			  	  <option value=""  <%if(gubun6.equals("")){%> selected <%}%>>��ü</option>
        			  	  <option value="1" <%if(gubun6.equals("1")){%> selected <%}%>>1�б�</option>
        			  	  <option value="2" <%if(gubun6.equals("2")){%> selected <%}%>>2�б�</option>
        			  	  <option value="3" <%if(gubun6.equals("3")){%> selected <%}%>>3�б�</option>
        			  	  <option value="4" <%if(gubun6.equals("4")){%> selected <%}%>>4�б�</option>
        			  	</select></td>
				  	 <td width='100' id=tr_dt3 style="display:<%if(gubun2.equals("3")){%>''<%}else{%>none<%}%>">&nbsp;	
					  	<select name="gubun7">
        			  	  <option value="" <%if(gubun3.equals("")){%> selected <%}%>>��ü</option>        
        			  	  <% for(int i=1; i<=12; i++){%>        
        			  	  <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun7)){%> selected <%}%>><%=AddUtil.addZero2(i)%>��</option>
        			  	  <%}%>
        			  	</select></td>
				  	  <td width='200' id=tr_dt4 style="display:<%if(gubun2.equals("4")){%>''<%}else{%>none<%}%>">&nbsp;
                  	      <input type="text" name="st_dt" size="11" value="<%=st_dt%>" class="text">
						    ~
						  <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text"></td>
				    </tr>
				  </table>
				</td>
              </tr>
			  <tr>
                <td width="10%" class="title">��������</td>
                <td width="40%">&nbsp;
					<input type="radio" name="gubun3" value=""  <%if(gubun3.equals(""))%>checked<%%>>
            		��ü
            		<input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>
            		���뿩
            		<input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>
            		�뵵����
            		<input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>
            		�Ű�
            		<input type="radio" name="gubun3" value="4" <%if(gubun3.equals("4"))%>checked<%%>>
            		����
				</td>			  
			    <td width="10%" class="title">���α���</td>
				<td >&nbsp;
					<input type="radio" name="gubun4" value=""  <%if(gubun4.equals(""))%>checked<%%>>
            		��ü
            		<input type="radio" name="gubun4" value="1" <%if(gubun4.equals("1"))%>checked<%%>>
            		�̳�
            		<input type="radio" name="gubun4" value="2" <%if(gubun4.equals("2"))%>checked<%%>>
            		����
				</td>
			  </tr>					  			  
              <tr>
                <td width="10%" class="title">�˻�����</td>
                <td width="40%">&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ/����</option>
                    <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����ȣ</option>
                    <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>������ȣ</option>
					<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>�����ȣ</option>
                    <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>����</option>				
                  </select>
					&nbsp;&nbsp;&nbsp;
					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td width="10%" class="title">��������</td>
                <td width="40%">&nbsp;
                  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%> selected <%}%>>��ȣ</option>
                        <option value='2' <%if(sort.equals("2")){%> selected <%}%>>������ȣ</option>
                        <option value='3' <%if(sort.equals("3")){%> selected <%}%>>�����ȣ</option>						
	                    <option value='4' <%if(sort.equals("4")){%> selected <%}%>>�����Һ�</option>						   
                        <option value='5' <%if(sort.equals("5")){%> selected <%}%>>�����߻���</option>	
                        <option value='6' <%if(sort.equals("6")){%> selected <%}%>>��������</option>											
                      </select>
					&nbsp;&nbsp;&nbsp;
					<input type='radio' name='asc' value='0' <%if(asc.equals("0")){%> checked <%}%> onClick='javascript:search()'>
                      �������� 
                      <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%> checked <%}%>onClick='javascript:search()'>
                      �������� 
					  </td>					

              </tr>
            </table></td>
    </tr>
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	 
</table>
</form>
</body>
</html>

