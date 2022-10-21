<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //�����
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//���÷��� Ÿ��(�˻�) -�˻����� ���ý�
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //�����
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
		}
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='forfeit_r_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > ���·���� > <span class=style1><span class=style5>����ȸ���������·�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                          <select name="gubun1">
                            <option value="" >��ü</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>������</option>
                            <!--<option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>���������</option>-->
                          </select>
                    </td>
                    <td colspan="2"><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                          <select name="gubun2">
                            <option value="" >��ü</option>
            			    <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>�����ں���</option>
            			    <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>������</option>
                            <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>ȸ��볳</option>
            			    <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>���ݳ���</option>
							<option value="5" <%if(gubun4.equals("5")){%>selected<%}%>>�����ں�������</option>
                          </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width='16%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                          <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                            <option value="" >����</option>
                            <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>������ȣ</option>
                            <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>��������</option>
                            <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>�������</option>
                            <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>���ݳ���</option>				
                            <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>��������ȣ</option>																
                            <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>û�����</option>					
                            <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>���·�</option>
                            <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>�����</option>
                          </select>
                    </td>
                    <td width='15%'> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                  <td id='td_input' <%if(s_kd.equals("8")){%> style='display:none'<%}%>> 
                                    <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                                  </td>
                                  <td id='td_bus' <%if(s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name='s_bus'>
                                    	  <option value="">������</option>
                                         <%if(user_size > 0){
                								for(int i = 0 ; i < user_size ; i++){
                									Hashtable user = (Hashtable)users.elementAt(i); 
                							%>
                							  <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                			                <%	}
                							}		%>
                                      </select> </td>
                            </tr>
                        </table>
                    </td>
                    <td width='13%'><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                          <select name='sort_gubun'>
                            <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>��������</option>
                            <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>��������</option>
                            <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>���α���</option>							
                            <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>������ȣ</option>
                            <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>û�����</option>
                            <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>�����</option>							
                          </select>
                    </td>
                    <td width='15%'> 
                        <input type='radio' name='asc' value='0' <%if(asc.equals("0")){%> checked <%}%>>
                        �������� 
                        <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%> checked <%}%>>
                        �������� </td>
                    <td><a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					</td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
