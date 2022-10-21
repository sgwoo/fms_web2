<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String st_dt="";
	String end_dt="";
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	   st_dt 	= AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+"01";		
	  end_dt = AddUtil.getDate();
	}
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	LoginBean login = LoginBean.getInstance();
	String dept_id = login.getDept_id(ck_acar_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function Search(){
		var fm = document.form1;		
		fm.action="parts_s_sc.jsp";
		fm.target="c_body";		
		fm.submit();
	}		
	
-->
</script>

</head>

<body onLoad="document.form1.t_wd.focus();">
<form  name="form1" method="POST" target="c_body">

 <input type='hidden' name='sh_height' value='<%=sh_height%>'>

  <table width="100%" border="0" cellspacing="1" cellpadding="0">
  		<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>정비관리 >  부품관리 >  <span class=style5>거래명세서관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
     <tr> 
         <td width=19%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp; 
        <select name="s_gubun1" >
          <option value="1" <%if(s_gubun1.equals("1")){%> selected <%}%>>출고일자&nbsp;</option>   
        </select>	
        </td>
           <td width=20%> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td> 
                      <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
                    </td>           
                </tr>
            </table>
        </td>
           
        <td width=30%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jr.gif>&nbsp;
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%> selected <%}%>>차량번호</option>
      
            </select>
            &nbsp;<input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> >
            오름차순 
            <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%> >
        내림차순 </td>
      <td><a href="javascript:Search()"><img src=/acar/images/center/button_search.gif align="absmiddle" border="0"></a> 
      
        <td align="right"></td>
        
      </td>
      </tr>
      
     <tr> 
        <td width=19%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif>&nbsp;
            <select name="s_kd" >
              <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
              <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>차량번호</option>

           </select>
        </td>
        <td width=15%> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td> 
                      <input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
                    </td>           
                </tr>
            </table>
        </td>
        <td width=30%> </td>
        <td align="right"></td>
        
     
    </tr>
    
</table>
</form>
</body>

</html>

