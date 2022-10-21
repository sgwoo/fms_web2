<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*, acar.partner.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Hashtable ht = se_dt.getServOff(off_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//네오엠 거래처 정보
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
	Vector vt = se_dt.Bank_accList(off_id);
	int vt_size = vt.size();
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
		var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0

		if( popObj != null ){
			popObj.close();
			popObj = null;
		}

		theURL = "http://fms1.amazoncar.co.kr/data/bank_acc/"+theURL+""+file_type;

		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		
		popObj.location = theURL;
		popObj.focus();
	
	}
	
	function ServOffUpDisp(){
		location.href = "cus0601_d_cont_u.jsp?auth_rw=<%= auth_rw %>&off_id=<%= off_id %>";
	}

	//계좌추가
	function scan_reg(off_st, off_id, seq, file_st ){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&off_st="+off_st+"&off_id=<%= off_id %>&seq="+seq+"&file_st="+file_st+"&cmd=in", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	//계좌수정
	function scan_modify(seq, bank_id){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&off_id=<%= off_id %>&bank_id="+bank_id+"&seq="+seq+"&cmd=up", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function off_upd(off_id){
	var SUBWIN="serv_off_i.jsp?auth_rw=<%= auth_rw %>&cmd=u&off_id="+off_id;
	window.open(SUBWIN, "SERVOFFUPD", "left=100, top=120, width=900, height=300, scrollbars=no");
}

//-->
</script>
</head>
<body leftmargin="10">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="15%">관리구분</td>
					<td align='center' width="20%">&nbsp;<%if(ht.get("CAR_COMP_ID").equals("0001")){%>금융
					<%}else if(ht.get("CAR_COMP_ID").equals("0002")){%>IT
					<%}else if(ht.get("CAR_COMP_ID").equals("0003")){%>지정정비업체
					<%}else if(ht.get("CAR_COMP_ID").equals("0004")){%>자동차부품(타이어등)
					<%}else if(ht.get("CAR_COMP_ID").equals("0005")){%>외주/협력업체
					<%}else if(ht.get("CAR_COMP_ID").equals("0006")){%>부동산
					<%}else if(ht.get("CAR_COMP_ID").equals("0007")){%>관공서
					<%}else if(ht.get("CAR_COMP_ID").equals("0008")){%>구매
					<%}else if(ht.get("CAR_COMP_ID").equals("0009")){%>매각(경매장등)<%}%>
					</td>
					<td class=title width="15%">상호</td>
                    <td colspan="" align=center  width="40%">&nbsp;<a href="javascript:off_upd('<%=ht.get("OFF_ID")%>')"><%=ht.get("OFF_NM")%></a></td>
				</tr>
                <tr> 
                    <td class=title width="10%">지점구분</td>
                    <td align=center >&nbsp;<%if(ht.get("BR_ID").equals("S1")){%>본사
					<%}else if(ht.get("BR_ID").equals("B1")){%>지점
					<%}%>
					</td>
                    <td class=title>대표전화</td>
                    <td align="center">&nbsp;<%=ht.get("OFF_TEL")%></td>
				</tr>
				<tr>
					<td class=title>주소</td>
					<td colspan=3>&nbsp;( <%=ht.get("OFF_POST")%> )&nbsp;<%=ht.get("OFF_ADDR")%></td>
				</tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
   
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>거래내용</td>
					<td align="center" colspan="2">&nbsp;<%=ht.get("NOTE")%></td>
					<td class=title>대출거래잔액<br>(<%=save_dt%>)</td>
					<td align="center" colspan="2">&nbsp;<span style="color: red;"><%=AddUtil.parseDecimal2(mon_amt)%></span></td>
				</tr>
                <tr> 
                    <td class=title width="15%">최초등록일자</td>
                    <td align="center" width="15%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td class=title width="15%">최초거래개시일자</td>
                    <td align="center" width="15%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%></td>
					<td class=title width="15%">거래종료일자</td>
                    <td align="center" width="15%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLOSE_DT")))%></td>
				</tr>
				 <tr>
                    <td class=title>비고</td>
                    <td align="center" colspan="5">&nbsp;<%=ht.get("DEAL_NOTE")%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="10%">거래계좌</td>
					<td align='center' colspan="3"><a href="javascript:scan_reg('serv_off','<%=ht.get("OFF_ID")%>','<%=vt_size+1%>','1')">[계좌추가]</a></td>
				</tr>
                <tr> 
                    <td class=title width="10%">은행명</td>
					<td class=title width="15%">계좌번호</td>
					<td class=title width="10%">사본</td>
					<td class=title width="65%">적요</td>
				</tr>
		<% if(vt_size > 0)	{
			for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht2 = (Hashtable)vt.elementAt(i);
					
		%> 				
				 <tr>
                    <td align="center">&nbsp;<a href="javascript:scan_modify('<%=ht2.get("SEQ")%>','<%=ht2.get("BANK_ID")%>')"><%=c_db.getNameById((String)ht2.get("BANK_ID"),"BANK")%></a></td>
                    <td align="center">&nbsp;<%=ht2.get("ACC_NO")%></td>
					<td align="center">
					<a href="javascript:ScanOpen('<%= ht2.get("FILE_NAME1") %>','<%=ht2.get("FILE_GUBUN1") %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					</td>
                    <td align="">&nbsp;<%=ht2.get("ETC")%></td>
                </tr>
		<%}
		}%>				
            </table>
        </td>
    </tr>

</table>
</body>
</html>