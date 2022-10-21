<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	document.domain = "amazoncar.co.kr";
	
	//등록하기
	function save(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;
		
		//캠페인금액 지급은 별도로 년도, 분기 값을 받는다. 
		
		if ( mode == '12' || mode == '13' || mode == '25' || mode == '26' || mode == '27'   || mode == '28'  || mode == '29' || mode == '30') {  //영업/채권/비용/제안캠페인지급금액 
			var SUBWIN="set_end_popup.jsp?mode="+mode+"&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		 	window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");
		} else {
		
			if(!confirm(ment+'을 마감하시겠습니까?'))
				return;
				
			fm.action = 'stat_end_null.jsp';
						
			if(mode == '9'){//통합영업캠페인
				fm.action = '/acar/stat_month/campaign2009_6_null.jsp';
			}
			
			if(mode == '15'){//관리비용캠페인
		//		fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/man_cost_campaign_null.jsp';
			}
			
			if(mode == '22'){//제안캠페인
				fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/prop_campaign_null.jsp';
			}
			fm.target = 'i_no';
			
			
			fm.submit();	
		}		
	}	
	
	//등록하기
	function save2(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;
		
		if(!confirm(ment+'을 마감하시겠습니까?'))
			return;
						
		if(mode == '8'){//채권비용캠페인						
			fm.action = '/acar/admin/stat_end_null_200911.jsp';
		}	
		
			 
		if(mode == '15'){//관리비용캠페인
		//	fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/man_cost_campaign_null.jsp';	
		}
		
		if(mode == '22'){//제안캠페인
			fm.action = 'https://fms3.amazoncar.co.kr/fms2/mis/prop_campaign_null.jsp';	
		}
		
		fm.target = 'i_no';
		
			
		fm.submit();	
	}
	
	
	//등록하기
	function save1(ment, mode){
		var fm = document.form1;	
		fm.mode.value = mode;		
		//캠페인금액 지급은 별도로 년도, 분기 값을 받는다. 
		
		if ( mode == '12' || mode == '13' || mode == '25' || mode == '26' || mode == '27'   || mode == '28'  || mode == '29' || mode == '30') {  //영업/채권/비용/제안캠페인지급금액 
			var SUBWIN="set_end_popup_file.jsp?mode="+mode+"&user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		 	window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");
		} 
					
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "11", "04", "01");


%>
<form action="stat_end_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='mode' value=''>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>마감관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td colspan="3" align=right><img src=../images/center/arrow_gji.gif align=absmiddle> <font color="#666666"><b>: <%=AddUtil.getDate()%></b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>부채 현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('부채 현황','2');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>		
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_debt_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>	
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차 현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('자동차 현황','3');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_car_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사원별 대여료 연체현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('대여료 연체 현황','1');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_dly_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사원별 관리영업현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('관리영업현황','5');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_mng_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사원별 영업실적현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('영업실적현황','6');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_bus_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사원별 인사평점현황</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save2('인사평점현황','7');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_total_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3>※ 사원별 인사평점현황은 채권캠페인+사원별관리영업현황+사원별영업실적현황이 선마감되어야 마감됩니다.</td>
    </tr>	
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td style="background-color:666666 height=1"</td>
    </tr>	
    <tr>
        <td></td>
    </tr>

    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권캠페인</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_settle_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr>
        <td colspan=3></td>
    </tr>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>통합영업캠페인</span></td>
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="stat_end_bus_cmp_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3"> 
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>관리비용캠페인</span></td>
        <td align="right"> 
        </td>
    </tr>
       <tr> 
        <td colspan="2"><iframe src="stat_end_cost_list.jsp?gubun=m&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr> 
    <tr> 
        <td colspan="3"> 
        </td>
    </tr>   
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>제안캠페인</span></td>
        <td align="right"> 
        </td>
    </tr>
       <tr> 
        <td colspan="2"><iframe src="stat_end_prop_list.jsp?gubun=p&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="55" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="3"><hr></td>
    </tr>
	
    <tr> 
        <td colspan="3">&nbsp;</td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업캠페인지급금액</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('영업캠페인지급','12');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('영업캠페인파일','12');">파일등록</a>
        <%}%>
        </td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권캠페인지급금액</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('채권캠페인지급','13');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('채권캠페인파일','13');">파일등록</a>
        <%}%>
        </td>
    </tr>
    
    
      <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>비용(1군)캠페인지급금액</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('비용(1군)캠페인지급','30');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('비용(1군)캠페인파일','30');">파일등록</a>
        <%}%>
        </td>
    </tr>
    
      <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>비용(2군)캠페인지급금액</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('비용(2군)캠페인지급','29');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('비용(2군)캠페인파일','29');">파일등록</a>
        <%}%>
        </td>
    </tr>
    
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>제안캠페인지급금액</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('제안캠페인지급','26');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:save1('제안캠페인파일','26');">파일등록</a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td> <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>관리대수분기마감</span></td>
        <td align="right"> 
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        <a href="javascript:save('관리대수분기마감','27');"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>