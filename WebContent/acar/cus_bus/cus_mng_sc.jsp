<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
				
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15 rightmargin=0>  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
    	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    	        <tr>
    	            <td class=line2></td>
    	        </tr>
                <tr>
                    <td class="line">
            		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td style="font-size:8pt" width='3%' rowspan="2" class='title'>연번</td>
                                <td style="font-size:8pt" width='8%' rowspan="2" class='title'>계약번호</td>
                                <td style="font-size:8pt" rowspan="2" class='title'>상호</td>
                                <td style="font-size:8pt" width='6%' rowspan="2" class='title'>차량번호</td>
                                <td style="font-size:8pt" width='7%' rowspan="2" class='title'>차종</td>
                                <td style="font-size:8pt" width='6%' rowspan="2" class='title'>등록일</td>
                                <td style="font-size:8pt" width='6%' rowspan="2" class='title'>계약일</td>
                                <td style="font-size:8pt" width='5%' rowspan="2" class='title'>받을어음</td>
                                <td style="font-size:8pt" width='5%' rowspan="2" class='title'>연체일</td>
                                <td style="font-size:8pt" width='3%' rowspan="2" class='title'>연체<br>개월</td>
                                <td style="font-size:8pt" width='5%' rowspan="2" class='title'>연체<br>금액</td>
                                <td style="font-size:8pt" width='5%' rowspan="2" class='title'>관리<br>구분</td>
                                <td style="font-size:8pt" width='3%' rowspan="2" class='title'>용도<br>구분</td>
                                <td style="font-size:8pt" width='6%' rowspan="2" class='title'>차량<br>이용지역</td>								
                                <td style="font-size:8pt" width='8%' rowspan="2" class='title'>지역<br>(고객주소)</td>
                                <td style="font-size:8pt" width='3%' rowspan="2" class='title'>대여<br>개월</td>
                                <td style="font-size:8pt" colspan="3" class='title'>담당자</td>
                            </tr>
                            <tr>
                                <td style="font-size:8pt" width='4%' class='title'>최초<br>영업</td>
                                <td style="font-size:8pt" width='4%' class='title'>영업</td>
                                <td style="font-size:8pt" width='4%' class='title'>관리</td>
                            </tr>
                        </table>
    		        </td>
    		        <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><iframe src="./cus_mng_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&sort=<%=sort%>" name="contList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
