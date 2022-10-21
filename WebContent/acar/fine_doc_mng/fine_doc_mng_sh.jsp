<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
	
	Vector fines = FineDocDb.getFineDocRegGovList(br_id);
	int fine_size = fines.size();
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="../../include/table_ts.css">
</head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���÷��� Ÿ��
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�Ⱓ
			td_dt1.style.display 	= '';
			td_dt2.style.display 	= 'none';			
		}else{
			td_dt1.style.display 	= 'none';
			td_dt2.style.display 	= '';			
		}
	}			
	
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function set_order_selbox(val){
		var fm = document.form1;
		if(val==""){
			$("#sort option[value!='anything']").prop('disabled',false);
		}else{
			$("#sort option[value='"+val+"']").prop('selected',true);
			$("#sort option[value!='"+val+"']").prop('disabled',true);
		}
	}
		
//-->
</script>
<body>
<form name='form1' action='fine_doc_mng_sc.jsp' target='c_foot' method='post'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ���·���� > <span class=style5>���ǽ�û�����������</span></span></td>
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
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td width=350><img src=/acar/images/center/arrow_ssc.gif align=absmiddle border="0">&nbsp;
                      <select name="gubun1">
                        <option value="" <%if(gubun1.equals(""))%>selected<%%>>��ü</option>
                        <%if(fine_size > 0){
        										for (int i = 0 ; i < fine_size ; i++){
        											Hashtable fine = (Hashtable)fines.elementAt(i);	%>
                        <option value='<%=fine.get("GOV_ID")%>' <%if(gubun1.equals(fine.get("GOV_ID"))) out.println("selected");%>><%=fine.get("GOV_NM")%></option>
                        <%	}
        									}
        								%>
                      </select>
                    </td>
                    <td width=140><img src=/acar/images/center/arrow_shij.gif align=absmiddle border="0">&nbsp;
                      <select name="gubun2" onChange='javascript:cng_dt()'>
                        <option value="">��ü</option>
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>������</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>����</option>
                        <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>����</option>
                        <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>���</option>
                        <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>�Ⱓ</option>
                      </select>
                    </td>
                    <td width=190> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="100%" id=td_dt1 style="display:<%if(!gubun2.equals("5")){%>none<%}else{%>''<%}%>"> 
                                    <input type="text" name="st_dt" size="11" value="<%=AddUtil.ChangeDate2(st_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                    ~ 
                                    <input type="text" name="end_dt" size="11" value="<%=AddUtil.ChangeDate2(end_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                </td>
                                <td width="100%" id=td_dt2 style="display:<%if(gubun2.equals("5")){%>none<%}else{%>''<%}%>">&nbsp; 
                                </td>
                            </tr>
                        </table>
                    </td>            
                    <td><img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle border="0">&nbsp;
                      <select name="s_kd">
                        <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü</option>
                        <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
                        <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>������ȣ</option>
                        <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>��������ȣ</option>
                        <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>��������</option>
                        <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>�����</option>
                        <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>����ó</option>				
                        <option value="7" <%if(s_kd.equals("7")){%> selected <%}%>>������ȣ</option>				
                      </select>
                      &nbsp;&nbsp;<input type="text" name="t_wd" size="24" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>&nbsp;&nbsp;
                   	  <select name="gubun3" onchange="javascript:set_order_selbox(this.value);">
                   		  <option value="">��ü</option>
	                   	  <option value="1">����24</option>
	                   	  <option value="2">�μ�</option>
                   		  <option value="3">FAX</option>
                   		  <option value="4">Ȩ���������</option>
                   		  <option value="5">��ó��</option>
                   	  </select>
                      </td>
                    <td>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif  align=absmiddle border="0">&nbsp;
                      <select name="sort" id="sort">
                        <option value="5" <%if(sort.equals("5")){%> selected <%}%>>��ó��</option>
                        <option value="1" <%if(sort.equals("1")){%> selected <%}%>>����24</option>
                        <option value="2" <%if(sort.equals("2")){%> selected <%}%>>�μ�</option>
                        <option value="3" <%if(sort.equals("3")){%> selected <%}%>>FAX</option>
                        <option value="4" <%if(sort.equals("4")){%> selected <%}%>>Ȩ���������</option>
                        <option value="" <%if(sort.equals("")){%> selected <%}%>>������ȣ</option>
                      </select>
                    </td>
                    <td>&nbsp;<a href='javascript:search()'><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
