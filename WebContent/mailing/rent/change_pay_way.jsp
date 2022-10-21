<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.insur.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase i_db = InsDatabase.getInstance();
	
	
	String client_id 		= request.getParameter("client_id")		==null?"":request.getParameter("client_id");
	String user_id 		= request.getParameter("user_id")		==null?"":request.getParameter("user_id");
	String bus_id2 		= request.getParameter("bus_id2")		==null?"":request.getParameter("bus_id2");
	String pay_way 	= request.getParameter("pay_way")		==null?"":request.getParameter("pay_way");
	
		
	//고객의 모든 차량 리스트
//	Vector client_vt = i_db.getIjwListmailing(client_id);	 //임직원전욤 고객은 전체대상이 아님.	
//	int client_vt_size = client_vt.size();		
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
		
	
//	for(int k=0;k<1;k++){							
//		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		//발신자 사용자 정보 조회
		user_bean 	= umd.getUsersBean(bus_id2);
		user_id = user_bean.getUser_id();
//	}
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 장기대여 대여료의 결제수단 안내</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #333333; line-height:19px;}
.style3 {color: #ff8004}
.style4 {color: #a74073; font-weight: bold;font-size:14px;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.button{background-color:#6d758c;font-size:12px;cursor:pointer;border-radius:2px;color:#fff;border:0;outline:0;padding:5px 8px;margin:3px;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>            		
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/layout_top_pay_way.png></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left" style="font-family:nanumgothic;font-size:12px;"><b><%=client.getFirm_nm()%> </b>님</td>
                    <td width=221 align="left" style="font-family:nanumgothic;font-size:12px;"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("권웅철")){%>유재석<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636 align=center>
                        <table width=98% border=0 cellspacing=0 cellpadding=0>

                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">
                            		1. <%=client.getFirm_nm()%> 고객님, 당사와 거래에 진심으로 감사 말씀드리며, 고객님의 일익 번창하심을 기원합니다.<br>
                            		2. 고객님께서 이용하고 계신 자동차 대여료 지불수단과 관련한 문의에 다음과 같이 안내의 말씀 드립니다. <br>
                            		자세한 내용은 아래의 <b>자동차 장기대여 대여료의 결제수단 안내</b> 링크를 참고하시기 바랍니다.
                            	</td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr> 
                            <tr>
                                <td height=18 align="left" style="font-family:nanumgothic;font-size:13px;">아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                	<td align=center>
                		<a href=http://fms1.amazoncar.co.kr/fms2/lc_rent/lc_c_h_confirm_template2.jsp?client_id=<%=client_id%>&bus_id2=<%=bus_id2%>&pay_way=<%=pay_way%> target="_blank">
                			자동차 장기대여 대여료의 결제수단 안내
                		</a>
                	</td>
                </tr>
                 
                <tr>
                    <td height=20></td>
                </tr>

				<tr>
					<td height=30></td>
				</tr>                
            </table>
        </td>
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
                    <td width=85><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
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