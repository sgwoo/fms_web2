<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.cooperation.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	//고객업무협조요청
	cp_bean = cp_db.getCooperationBean(seq);
	
	//고객정보
	ClientBean client = al_db.getNewClient(cp_bean.getClient_id());
	
	UsersBean acter_bean 	= umd.getUsersBean(cp_bean.getSub_id());
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>안내문</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #2e4168; font-weight: bold;}
.style2 {color: #636262}
.style10 {color: #0441da}
.style11 {
	color: #ff00ff;
	font-weight: bold;
}
-->
</style>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ask/images/img_bg.gif>
                <tr>
                    <td valign=bottom background=https://fms5.amazoncar.co.kr/mailing/ask/images/img_1.gif height=250 align=right>
                    <img src=https://fms5.amazoncar.co.kr/mailing/ask/images/ani.gif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td align=center>                
                                    <table width=510 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=18 class=style2><span class=style10><b><%=client.getFirm_nm()%></b></span>고객님</td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=18 class=style2>요청하신 사항이 아래와 같이 완료되었음을 알려드립니다.</td>
                                        </tr>
                                        <tr>
                                            <td height=18 class=style2>궁금하신 부분이 있으시면 <span class=style10>아래 담당자</span>에게 연락하시기 바랍니다.</td>
                                        </tr> 
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=40></td>
                            </tr>
                            <tr>
                                <td align=center>
                                    <table width=510 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=125><img src=https://fms5.amazoncar.co.kr/mailing/ask/images/bar_1.gif></td>
                                            <td class=style2><%=cp_bean.getTitle()%></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                        <tr>
                                            <td  valign=top><img src=https://fms5.amazoncar.co.kr/mailing/ask/images/bar_2.gif></td>
                                            <td>
                                                <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td class=style2><%=cp_bean.getOut_content()%></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/ask/images/bar_3.gif></td>
                                            <td class=style2><%=cp_bean.getOut_dt()%></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/ask/images/bar_4.gif></td>
                                            <td class=style2><%=acter_bean.getUser_nm()%> ( <%if(acter_bean.getLoan_st().equals("")){%><%=acter_bean.getHot_tel()%><%}else{%><%=acter_bean.getUser_m_tel()%><%}%> ) </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ask/images/img_2.gif></td>
                </tr>
            </table> 
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png ></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>