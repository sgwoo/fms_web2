<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
	if(gubun1.equals("") && gubun2.equals("")){
		UserMngDatabase umd = UserMngDatabase.getInstance();
		UsersBean user_bean = umd.getUsersBean(user_id);
		
		if(!user_bean.getLoan_st().equals("")){
			gubun1 = user_bean.getBr_id();
			gubun2 = user_bean.getUser_nm();
		}				
	}	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
				   	"&sh_height="+height+"";
				   	
	CommonDataBase c_db = CommonDataBase.getInstance();
					   	
	//영업소리스트
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size = branches.size();				   	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		fm.mode.value = '';
		fm.action="ins_com_emp_stat_sc_in.jsp";					
		fm.target="inner";		
		fm.submit();
	}
	
	function pop_list(){
		var fm = document.form1;
		fm.mode.value = 'pop';
		fm.action = 'ins_com_emp_stat_list.jsp';
		fm.target = '_blank';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="10">

<form name='form1' method='post' target='d_content' action='ins_com_emp_stat_sc_in.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>  
  <input type='hidden' name='mode'	value=''>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/insure/ins_com_emp_stat_sc.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>임직원운전한정특약관리현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td> 
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                <tr> 
          	    <td>&nbsp;&nbsp;&nbsp;
			지점 : 
			<select name='gubun1'>
                          <option value=''>전체</option>
                          <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%=branch.get("BR_ID")%>' <%if(gubun1.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                          <%		}
            					}%>
                        </select>
                        &nbsp;&nbsp;&nbsp;
                        담당자 : <input type='text' name='gubun2' size='10' class='text' value='<%=gubun2%>' style='IME-MODE: active'>  
                        &nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>            
                    </td>         
                </tr>
            </table>
        </td>   
    </tr>    
    <tr>
	<td></td>
    </tr>
    <tr>
	<td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td>
			<iframe src="ins_com_emp_stat_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>
