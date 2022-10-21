<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.stat_inc.*, acar.account.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 5; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈

%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>수금스케줄현황</span></span></td>
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
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=8% class='title' align="center">구분</td>
                    <td colspan="2" class='title' align="center">선수금</td>
                    <td colspan="2" class='title' align="center">대여료</td>
                    <td colspan="2" class='title' align="center">과태료</td>
                    <td colspan="2" class='title' align="center">면책금</td>
                    <td colspan="2" class='title' align="center">휴/대차료</td>
                    <td colspan="2" class='title' align="center">해지정산금</td>
                    <td colspan="2" class='title' align="center">합계</td>
                </tr>
                <tr align="center"> 
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=9% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=10% class='title'>금액</td>
                </tr>
<%	//검색통계 현황
	StatIncDatabase sid = StatIncDatabase.getInstance();
	Vector inss = sid.getStatIncListStat(br_id, gubun1, gubun2, gubun3, st_dt, end_dt);
	int ins_size = inss.size();
	if(ins_size > 0){
		for (int i = 0 ; i < ins_size ; i++){
			IncomingBean ins = (IncomingBean)inss.elementAt(i);%>				  
                <tr> 
                    <td class='title'><%=ins.getGubun()%></td>
                    <td align="right"><%=ins.getTot_su1()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt1())%>원</td>
                    <td align="right"><%=ins.getTot_su2()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt2())%>원</td>
                    <td align="right"><%=ins.getTot_su3()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt3())%>원</td>
                    <td align="right"><%=ins.getTot_su4()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt4())%>원</td>
                    <td align="right"><%=ins.getTot_su5()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt5())%>원</td>
                    <td align="right"><%=ins.getTot_su6()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt6())%>원</td>
                    <td align="right"><%=ins.getTot_su1()+ins.getTot_su2()+ins.getTot_su3()+ins.getTot_su4()+ins.getTot_su5()+ins.getTot_su6()%>건</td>
                    <td align="right"><%=Util.parseDecimal(ins.getTot_amt1()+ins.getTot_amt2()+ins.getTot_amt3()+ins.getTot_amt4()+ins.getTot_amt5()+ins.getTot_amt6())%>원</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="15" align="center">자료가 없습니다.</td>
		        </tr>
<%	}%>			  
            </table>
        </td>
    </tr>	  
    <tr>
	    <td align="right">
	        <a href="javascript:window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
    </tr>  
</table>
</body>
</html>
