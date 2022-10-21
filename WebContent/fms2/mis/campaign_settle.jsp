<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
			
	if(user_id.equals(""))	user_id = ck_acar_id;
    if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "09", "05", "05");
		
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	if(gubun1.equals("")) gubun1=AddUtil.getDate(1);
	
	String gubun2		= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
		
	int cnt = 3; //검색 라인수
	int sh_height = cnt*sh_line_height;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈
			
%>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function Search(){
	
		var fm = document.form1;
				
		if(fm.gubun1.value == ''){ alert('연도를 선택하십시오'); return;}
		var i_fm = i_view.form1;
		i_fm.gubun1.value = fm.gubun1.value;	
		i_fm.gubun2.value = fm.gubun2.value;	
						
		i_fm.target='i_view';
		if ( i_fm.gubun2.value == '1' ) { //채권이면
		    i_fm.action='campaign_settle_view1.jsp';	
		} else {	    
	    	i_fm.action='campaign_settle_view.jsp';		
		}
		i_fm.submit();				
	}
	

	//프린트화면보기	
	function cmp_print(){
		var fm = document.form1;
		var i_fm = i_view.form1;
		i_fm.gubun1.value = fm.gubun1.value;	
		i_fm.gubun2.value = fm.gubun2.value;	
		if ( i_fm.gubun2.value == '6' ) {		
			window.open("campaign_settle_view_print.jsp?gubun2=6&gubun1="+i_fm.gubun1.value,"print","left=30,top=50,width=1050,height=850,scrollbars=yes");	
		} else {
			window.open("campaign_settle_view1_print.jsp?gubun2=1&gubun1="+i_fm.gubun1.value,"print","left=30,top=50,width=1050,height=850,scrollbars=yes");	
		}	
	}
	
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan=4>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>캠페인실적(내근)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td width="150">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yd.gif align=absmiddle>
              &nbsp;<select name="gubun1">
              
                <%for(int i=2015; i<=AddUtil.getDate2(1); i++){%>
                <option value="<%=i%>" <%if(gubun1.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>
        </td>
				   
		<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle> 
		 &nbsp;
			<select name="gubun2">        
            	<option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>채권캠페인</option>           
            	<option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>제안캠페인</option>
			</select>
		</td>	
        <td colspan=2>&nbsp;<a href="javascript:Search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>        
             &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>
             
        </td>

     
    </tr>
    <tr> 
        <td colspan="4">&nbsp;</td>
    </tr>		
    <tr> 
        <td colspan="4"><iframe src="./campaign_settle_view1.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>" name="i_view" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
</table>
</form>
</body>
</html>
