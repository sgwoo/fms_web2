<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.admin.*"%>
<%@ page import="acar.insur.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
	function search()
	{
	  //���� ����Ÿ ��������
	   var fm = document.form1;	   	  
	  
	   if (fm.s_kd.value == '5' || fm.s_kd.value == '6' || fm.s_kd.value =='10') {
	     if (fm.s_kd.value == '5' &&  fm.gubun1[0].checked == true ) {
	       	alert("�˻������� �Է��ϼž� �մϴ�.")
	    	 	return;
	     }
	   	    
	   } else { 	     
	     if (fm.t_wd.value == '') {
	     	alert("�˻������� �Է��ϼž� �մϴ�.")
	     	return;
	     }
	     
	   } 
	    fm.target = "c_foot";
	   	fm.action = "/fms2/cls_cont/lc_cls_d_sc.jsp";
	    document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function list_excel_cls(){
		fm = document.form1;
		if(fm.s_kd.value!='10'){
			alert('������� �Ⱓ�� ��ȸ�����մϴ�');
			return;
		}
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "lc_cls_excel.jsp";
		fm.submit();
	}		
	//���÷��� Ÿ��(�˻�) - ��ȸ�Ⱓ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'){ //�Ⱓ��ȸ����
			text_input.style.display	= 'none';
			text_input2.style.display	= '';
			fm.t_wd.value='';
			
		}else{
			text_input2.style.display	= 'none';
			text_input.style.display	= '';
			fm.st_dt.value='';
			fm.end_dt.value='';
		}
	}
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
		String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>
<form name='form1' action='/fms2/cls_cont/lc_cls_d_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > <span class=style5>�������깮��ó��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td width=30%>&nbsp;
            		    <select name='s_kd' onChange="javascript:cng_input1()">
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>����� </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�������� </option>
                    	  <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>���� </option>
                    	  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>����ݰ��װ�����</option>
                    	  <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>�������</option>
                    	  <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>��������</option>
							 <option value='10' <%if(s_kd.equals("10")){%>selected<%}%>>������� �Ⱓ�˻�</option>                        
                        </select>     			    
        			    <span id="text_input2" style="display:none;"><input type="text" name="st_dt" size="10" value="<%=ad_db.getPreDay(AddUtil.getDate(4), 1)%>" class="text">
													~
													<input type="text" name="end_dt" size="10" value="<%=AddUtil.getDate(4)%>" class="text">
												</span>
        			    <span id="text_input" <%if(!st_dt.equals("")){%>style="display:none;"<%}%>><input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></span>
        		    </td>
        		    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp;
            		  <select name='andor'>
            		      <option value=''  <%if(andor.equals("")){ %>selected<%}%>>--��ü--</option>
                          <option value='1' <%if(andor.equals("1")){%>selected<%}%>>��ุ��</option>
                          <option value='2' <%if(andor.equals("2")){%>selected<%}%>>�ߵ��ؾ�</option>
                          <option value='7' <%if(andor.equals("7")){%>selected<%}%>>���������(����)</option>
                          <option value='10' <%if(andor.equals("10")){%>selected<%}%>>����������(�縮��)</option>
                                                            
                      </select>
        			</td>		  	
                    <td class=title width=10%>���翩��</td>
                    <td width=15%>&nbsp;
            		    <input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
            			�̰�
            		    <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
            			����
        			</td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2">
        <%if(nm_db.getWorkAuthUser("�������",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
     			<a href="javascript:list_excel_cls();"><img src="/acar/images/center/button_bhex.gif"  border="0" align=absmiddle></a>
      		<%}%>
	     <a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
