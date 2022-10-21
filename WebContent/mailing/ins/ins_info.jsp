<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*,  acar.util.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins1"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="ins2"       class="acar.con_ins.InsurBean"             scope="page"/>


<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");
	
	String ins_com_nm1 = "삼성화재";
	String ins_com_nm2 = "동부화재";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase i_db = InsDatabase.getInstance();
	

	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	
	if(!String.valueOf(cont.get("CAR_MNG_ID")).equals("")){
	
		//현재 보험정보
		String ins_st = ai_db.getInsSt(String.valueOf(cont.get("CAR_MNG_ID")));
		
		//갱신전
		ins1 = ai_db.getIns(String.valueOf(cont.get("CAR_MNG_ID")), String.valueOf(AddUtil.parseInt(ins_st)-1));

		//갱신후
		ins2 = ai_db.getIns(String.valueOf(cont.get("CAR_MNG_ID")), ins_st);
		
		
		//보험사
		Hashtable ins_com1 = i_db.getInsCom(ins1.getIns_com_id());		
		Hashtable ins_com2 = i_db.getInsCom(ins2.getIns_com_id());		
		
		ins_com_nm1 = String.valueOf(ins_com1.get("INS_COM_NM"));
		ins_com_nm2 = String.valueOf(ins_com2.get("INS_COM_NM"));
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>자동차보험사변경 안내문</title>
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
            <!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    <!-- 날짜 -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right>&nbsp;</td>
                </tr> 
            </table>
    <!-- 날짜 -->
        </td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_bg.gif>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_up.gif width=677 height=44></td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/m_1.gif width=564 height=183></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=460 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=18><span class=style1><%=cont.get("FIRM_NM")%></span> 고객님</td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=18 class=style2>안녕하세요 아마존카입니다. </td>
                            </tr>
                            <tr>
                                <td height=18 class=style2>당사가 가입한 보험사가 기존 <span class=style10><%=ins_com_nm1%></span>에서 <span class=style10><%=ins_com_nm2%></span>로 변경되었음을 알려드립니다. </td>
                            </tr>
                            <tr>
                                <td height=18 class=style2>궁금하신 점이 있으시면 아래 담당자에게 연락하시기 바랍니다. </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=25>&nbsp;</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=424 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/m_bg.gif>
                            <tr>
                                <td colspan=2 height=3></td>
                            </tr>
                            <tr>
                                <td width=109 height=30 align=center class=style2>차량번호</td>
                                <td class=style2>&nbsp;&nbsp;<%=cont.get("CAR_NO")%></td>
                            </tr>
                            <tr>
                                <td height=29 align=center class=style2>차종</td>
                                <td class=style2>&nbsp;&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                            </tr>
                            <tr>
                                <td height=29 align=center class=style2>보험사</td>
                                <td class=style2>&nbsp;&nbsp;<del><%=ins_com_nm1%></del>&nbsp;&nbsp;&nbsp;-->&nbsp;&nbsp;&nbsp;<span class=style11><%=ins_com_nm2%></span></td>
                            </tr>
                            <tr>
                                <td height=29 align=center class=style2>변경일자</td>
                                <td class=style2>&nbsp;&nbsp;<%=AddUtil.getDate3(ins_start_dt)%></td>
                            </tr>
                            <tr>
                                <td height=30 align=center class=style2>담당자</td>
                                <td class=style2>&nbsp;&nbsp;<%=cont.get("USER_NM")%> ( <%=cont.get("USER_M_TEL")%> ) </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td><img src=images/ser_dw.gif width=677 height=44></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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