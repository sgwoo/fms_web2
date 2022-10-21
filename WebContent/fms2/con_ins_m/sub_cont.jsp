<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_accident.*, acar.car_service.*"%>
<jsp:useBean id="a_bean" class="acar.car_accident.AccidentBean" scope="page"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	if(title.equals("")){ 	title="면책금"; }
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%=title%> 세부내용</span></span></td>
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
<% 	if(gubun.equals("h") || serv_st.equals("사고수리")){
	//사고기록
	AddCarAccidDatabase a_cdb = AddCarAccidDatabase.getInstance();
	a_bean = a_cdb.getCarAccidCase(c_id, accid_id);
%>  
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=15% class='title'>사고구분</td>
                    <td width=35%>&nbsp;<%=a_bean.getAccid_st()%></td>
                    <td width=15% class='title'>운전자명</td>
                    <td width=35%>&nbsp;<%=a_bean.getOur_driver()%></td>
                </tr>
                <tr> 
                    <td class='title'>사고일자</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(a_bean.getAccid_dt().substring(0,8))%></td>
                </tr>
                <tr> 
                    <td class='title'>사고장소</td>
                    <td colspan="3">&nbsp;<%=a_bean.getAccid_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>사고내용</td>
                    <td colspan="3">
                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                            <tr>
                                <td><%=Util.htmlBR(a_bean.getAccid_cont())%> 
                                  <%if(!a_bean.getAccid_cont2().equals("")){%>
                                  <br>
                                  <%}%>
                                  <%=Util.htmlBR(a_bean.getAccid_cont2())%></td>
                            </tr>
                        </table>
                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>당사<br>과실비율</td>
                    <td>&nbsp;<%=a_bean.getOur_fault_per()%>%</td>
                    <td class='title'>경찰서<br>접수여부</td>
                    <td>&nbsp;<%=a_bean.getOt_pol_st()%></td>
                </tr>
          </table>
        </td>
    </tr>
<%	}
	if(gubun.equals("m")){
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	//정비/점검(면책금)
	s_bean = a_csd.getServiceCase(l_cd, c_id, accid_id, serv_id);
%>  
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=15% class='title'>정비구분</td>
                    <td width=35%>&nbsp;<%=s_bean.getServ_st_nm()%></td>
                    <td width=20% class='title'>정비일자</td>
                    <td width=30%>&nbsp;<%=s_bean.getServ_dt()%></td>
                </tr>
                <tr> 
                    <td class='title'>점검자</td>
                    <td>&nbsp;<%=c_db.getNameById(s_bean.getChecker(), "USER")%></td>
                    <td class='title'>현누적 주행거리</td>
                    <td >&nbsp;<%=s_bean.getTot_dist()%>km</td>
                </tr>
                <tr> 
                    <td class='title'>정비업체</td>
                    <td>&nbsp;<%=s_bean.getOff_nm()%></td>
                    <td class='title'>연락처</td>
                    <td>&nbsp;<%=s_bean.getOff_tel()%></td>
                </tr>
                <tr> 
                    <td class='title'>점검내용</td>
                    <td colspan="3">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;<%=s_bean.getRep_cont()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>  
    <tr> 
        <td align='right'><a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</body>
</html>