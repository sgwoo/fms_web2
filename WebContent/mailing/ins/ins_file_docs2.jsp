<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.insur.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>


<%
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	
	String[] file_seq = request.getParameterValues("file_seq");

	Vector vt = new Vector();
	Hashtable ht = null;
	for(int i=0; i < file_seq.length; i++){
		ht = ic_db.getInsComFileSelect(file_seq[i]);
		vt.add(ht);
	}
		
	
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>임직원 전용 자동차 보험 가입 요청서</title>
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
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<script language='JavaScript' src='/include/common.js'></script>

<script language="JavaScript">
<!--	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
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
        <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file2.png></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left" style="font-family:nanumgothic;font-size:12px;"><b><%=ht.get("FIRM_NM") %> </b>님</td>
                    <td width=221 align="left" style="font-family:nanumgothic;font-size:12px;"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=ht.get("REG_NM")%>&nbsp;&nbsp;(&nbsp;<%=ht.get("TEL")%>&nbsp;)</td>
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
                            		안녕하세요. <%=String.valueOf(ht.get("FIRM_NM"))%> 고객님 <br><br>
                            		아래 <b>첨부파일리스트</b>는 아마존카에서 이용하시는 차량의 가입 증명서 입니다.<br>
                            		아래 해당 <b>증권번호를</b> 클릭하시면 원하시는 가입증명서를 보실 수 있습니다.
                            		 
                            	</td>
                            </tr>
                            <tr>
                                <td height=15></td>
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
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/ins/images/e_bar_est_file.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
	                        <tr>
	                        	<td height=2 bgcolor=656e7f colspan=4></td>
	                        </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=40 width=30% align=center style="font-family:nanumgothic;font-size:12px;">고객</td>
                                <td bgcolor=f2f2f2 width=20% align=center style="font-family:nanumgothic;font-size:12px;">차종</td>
                                <td bgcolor=f2f2f2 width=20% align=center style="font-family:nanumgothic;font-size:12px;">차량번호</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">증권번호</td>
                            </tr>
                			<%														
							for(int k=0;k<vt.size();k++){
        							  Hashtable ht2 = (Hashtable)vt.elementAt(k);
 							%>
        						 <tr bgcolor=#ffffff>
        							<td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=String.valueOf(ht2.get("FIRM_NM"))%></td>
									<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht2.get("CAR_NM")%></td>
									<td align=center style="font-family:nanumgothic;font-size:12px;color:#a74073;"><%=ht2.get("CAR_NO")%></td>
									<td align=center style="font-family:nanumgothic;font-size:12px;"><a href="https://fms3.amazoncar.co.kr/fms2/attach/download2.jsp?SEQ=<%=ht2.get("SEQ")%>&SIZE=<%=ht2.get("FILE_SIZE") %>" title='보기' ><%=ht2.get("INS_CON_NO")%></a></td>
								 </tr>
						<% }%>                            
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td height=35></td>
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
</table> -
</body>
</html>