<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*"%>

<%
String content_seq 	= request.getParameter("content_seq")==null?"":request.getParameter("content_seq");
String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");

CommonDataBase 		c_db = CommonDataBase.getInstance();
AddClientDatabase 	acl_db = AddClientDatabase.getInstance();
String content_code  = "RECALL";
String seq 		= "";
String s_gubun 	= "";

Hashtable ht = acl_db.getClientOne(client_id);

Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
if(attach_vt.size()==1){
	for(int i=0; i < attach_vt.size(); i++){
		Hashtable file = (Hashtable)attach_vt.elementAt(i);
		seq 	= String.valueOf(file.get("SEQ"));
		s_gubun = String.valueOf(file.get("FILE_SIZE"));
	}
}
//int attach_vt_size = attach_vt.size();	
	
%>

<html>
<head>
<title>아마존카 리콜 안내문</title>
<meta http-equiv="Content-Type" content="text/html"; charset="euc-kr">
<script language='javascript'>
<!--
	
//-->
</script>
<style type="text/css">
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
        <td height=20></td>
    </tr>
    
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>

    <tr>
        <td height=40 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=685 border=0 cellspacing=0>
                <tr>
                	<td align="center" style="padding-top:50px;padding-bottom:50px;background:linear-gradient(#ffe4b5, #ffe4b5 30%, #68d168);border-radius: 15px;">
                		<table width=585 border=0 cellspacing=0  style="border: 10px solid #ebc680; border-radius: 10px;background-color: white;">
                			<tr>
			                    <td style="padding-top:30px;padding-bottom:30px;font-size: 30px;font-family: Nanumgothic, AppleMyungjo;font-weight: bold; padding-left:30px;"><div>리콜 안내문</div></td>
			                </tr>
			                <tr>
			                	<td style="padding-bottom:20px;font-size: 14px;color: #369f36; font-family:Nanumgothic; font-weight:bold;padding-left:30px;">
			                		<%=ht.get("FIRM_NM")%> 님
			                	</td>
			                </tr>
			                <tr>
			                	<td style="font-size: 14px;font-family:Nanumgothic; font-weight:bold; padding-left:30px; padding-right:30px;">
			                		<div style="color: #c90909">항상 저희 (주)아마존카를 이용해 주셔서 감사드립니다.</div><br>
			                		<div>현재 이용중인 자동차의 제조사로부터 리콜요청이 있어 <span style="color: #c90909">리콜안내문</span>을 <span style="color: #c90909">파일</span>로 첨부하여 보내드립니다.</div><br>
			                		<div>고객님께서 첨부 파일을 열어서 리콜내용을 확인하시고 안내문의 내용대로 자동차의 결함사항에 대해 무상수리를 받으시기 바랍니다.</div>
			                		<div>보다 자세한 리콜사항은 자동차리콜센터(<a href='http://www.car.go.kr'>www.car.go.kr</a> 리콜대상확인) 또는</div>
			                		<div>해당 자동차 제조사의 고객센터로 문의해 주시기 바랍니다.</div>
			                		<br><br>
			                		<div>※ 본 메일은 (주)아마존카에서 발송한 메일이며 발신전용 메일입니다.</div>
			                		
			                	</td>
			                </tr>
			                <tr>
			                	<td align="right" style="font-size: 14px;font-family:Nanumgothic; font-weight:bold; padding-left:30px; padding-right:30px;"><img alt="" src="http://fms1.amazoncar.co.kr/acar/images/sign_1.png" style="margin-top: 30px;">  </td>
			                </tr>
			                <tr>
			                	<td align="center" style="padding: 30px;">
			                    	<%-- <a  style="background-color:#6d758c;font-size:12px;cursor:pointer; border-radius:8px; color:#fff; border:0; outline:0; padding:5px 8px; margin:3px; text-decoration:none; "
			                    	 href="http://fms1.amazoncar.co.kr/mailing/recall/recall_email_detail.jsp?content_seq=<%=content_seq%>">리콜안내문 보기</a> --%>
			                    	 <a  style="background-color:#6d758c;font-size:12px;cursor:pointer; border-radius:8px; color:#fff; border:0; outline:0; padding:5px 8px; margin:3px; text-decoration:none; "
			                    	 href="https://fms3.amazoncar.co.kr/fms2/attach/view_normal_email.jsp?CONTENT_CODE=<%=content_code%>&SEQ=<%=seq%>&S_GUBUN=<%=s_gubun%>">리콜안내문 보기</a>
			                	</td>
			                </tr>
                		</table>
                	</td>
                </tr>
            </table>
        </td>
    </tr>   
	<tr>
		<td align=center height=50 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span></span></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=513><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
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

