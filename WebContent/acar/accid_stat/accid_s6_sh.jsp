<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();	
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���					
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.action="accid_s6_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	//�ٸ���Ȳ���� �̵�
	function cng_stat(){
		var fm = document.form1;
		if(fm.gubun1.value == "") 			fm.action="accid_s_frame.jsp";
		else if(fm.gubun1.value == "0") 	fm.action="accid_s1_frame.jsp";
		else if(fm.gubun1.value == "1") 	fm.action="accid_s2_frame.jsp";
		else if(fm.gubun1.value == "2") 	fm.action="accid_s3_frame.jsp";
		else if(fm.gubun1.value == "3") 	fm.action="accid_s4_frame.jsp";
		else if(fm.gubun1.value == "4") 	fm.action="accid_s5_frame.jsp";
		else if(fm.gubun1.value == "5") 	fm.action="accid_s6_frame.jsp";
		fm.target="d_content";		
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="./accid_s6_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type="hidden" name="gubun3" value="">
<input type="hidden" name="gubun4" value="">
<input type="hidden" name="gubun5" value="">
<input type="hidden" name="gubun6" value="">
<input type="hidden" name="s_kd" value="">
<input type="hidden" name="t_wd" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=6>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > �����Ȳ > <span class=style5>
						�����ü����Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>   	    
    <tr>
        <td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp; 
            <select name="gubun1">
              <option value=""  <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>��Ʈ</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>����</option>
            </select>
        </td>
        <td width=15%>
	    <%if(br_id.equals("S1")){%>	  
            <img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;          
            <select name='brch_id'>
              <option value=''>��ü</option>
              <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <%= branch.get("BR_NM")%> </option>
              <%	}
    			}%>
            </select>
		    <%}%>		
        </td>
        <td width=13%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;  
            <select name="gubun2" onChange="javascript:cng_input1()">
              <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>����</option>
              <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>�������</option>
              <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>���ؿ���</option>
              <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>���س⵵</option>
              <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>�����Է�</option>
              <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>��ü</option>
            </select>
        </td>
        <td width=16%> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td id='td_gubun2_1' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                      <select name="s_mon">
                        <%for(int i=1; i<13; i++){%>
                        <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td id='td_gubun2_2' <%if(gubun2.equals("5")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                      <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text" >
                      ~ 
                      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
                    </td>
                </tr>
            </table>
        </td>
        <td width=18%><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;  
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%> selected <%}%>>�����ü</option>
              <option value="2" <%if(sort.equals("2")){%> selected <%}%>>������Ǽ�</option>
              <option value="3" <%if(sort.equals("3")){%> selected <%}%>>������ݾ�</option>
            </select>
            <select name="asc">
              <option value="asc" <%if(asc.equals("asc")){%> selected <%}%>>����</option>
              <option value="desc" <%if(asc.equals("desc")){%> selected <%}%>>����</option>
            </select>
        </td>
        <td><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>