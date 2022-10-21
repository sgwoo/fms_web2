<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_modify()
	{
		location='/acar/bank_mng/bank_lend_u.jsp?lend_id='+document.form1.lend_id.value;
	}
	
	function reg_cont()
	{
		window.open('/acar/bank_mng/bank_mapping_i.jsp?lend_id='+document.form1.lend_id.value, "MAPPING", "left=100, top=100, width=700, height=400");
	}
	
	function mapping_list()
	{
		window.open('/acar/bank_mng/bank_con_c.jsp?auth_rw='+document.form1.auth_rw.value+'&lend_id='+document.form1.lend_id.value, "MAPPING_LIST", "left=100, top=100, width=700, height=400");
	}
	
	function go_to_list()
	{
		location='/acar/bank_mng/bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
	}	
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	BankLendBean bl = bl_db.getBankLend(lend_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector agnts = bl_db.getBankAgnts(lend_id);
	int agnt_size = agnts.size();
%>
<body leftmargin="15">
<form name="form1" method="POST">
<input type='hidden' name='lend_id' value='<%=bl.getLend_id()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td ><font color="navy">재무관리 -> 은행대출관리 -> </font><font color="red">대출조회</font></td>
    </tr>
    
    <tr>
    	<td>
			<table border="0" cellspacing="1" width=800>
				<tr>
			    	<td>< 은행정보 ></td>
			    	<td align='right'>
<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			    		<a href='javascript:go_modify();' onMouseOver="window.status=''; return true">수정화면</a>
<%	}%>
			    		&nbsp;&nbsp;<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true">리스트로</a>
			    	</td>
			    </tr>
			</table>
		</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td width='80' class=title>계약일</td>
                    <td width='150'>&nbsp;<%=bl.getCont_dt()%></td>
                    <td width='100' class=title>계약은행</td>
                    <td width='150'>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
                    <td width='80' class=title>계약구분</td>
                    <td width='180'>&nbsp;<%=bl.getCont_st()%></td>
                </tr>
                <tr>
                    <td class=title>은행지점</td>
                    <td>&nbsp;<%=bl.getBn_br()%></td>
                    <td class=title>지점전화번호</td>
                    <td>&nbsp;<%=bl.getBn_tel()%></td>
                    <td class=title>지점팩스번호</td>
                    <td>&nbsp;<%=bl.getBn_fax()%></td>
                </tr>
                
            </table>
        </td>
    </tr>
	<tr>
    	<td>< 계약정보 ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td width='80' class=title>대출번호</td>
                    <td width='90'>&nbsp;<%=bl.getLend_no()%></td>
                    <td width='70' class=title>대출금액</td>
                    <td width='90'>&nbsp;<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>원</td>
                    <td width='70' class=title>대출이율</td>
                    <td width='80'>&nbsp;<%=bl.getLend_int()%>(%)</td>
                    <td width='70' class=title>대출이자</td>
                    <td width='90'>&nbsp;<%=Util.parseDecimal(bl.getLend_int_amt())%>원</td>
                    <td width='70' class=title>상환총금액</td>
                    <td width='90'>&nbsp;<%=Util.parseDecimal(bl.getRtn_tot_amt())%>원</td>
                </tr>
                <tr>
                    <td class=title>상환개시일</td>
                    <td>&nbsp;<%=bl.getCont_start_dt()%></td>
                    <td class=title>상환만료일</td>
                    <td>&nbsp;<%=bl.getCont_end_dt()%></td>
                   	<td class=title>상환기간</td>
                    <td colspan='3'>&nbsp;<%=bl.getCont_start_dt()%>~<%=bl.getCont_end_dt()%></td>
                   	<td class=title>상환개월</td>
                    <td>&nbsp;<%=bl.getCont_term()%>개월</td>
                </tr>
                <tr>
             		<td class=title>상환약정일</td>
                    <td>&nbsp;<%=bl.getRtn_est_dt()%>일</td>
                    <td class=title>월상환금액</td>
                    <td>&nbsp;<%=Util.parseDecimal(bl.getAlt_amt())%>원</td>
                    <td class='title'>상환조건</td>
					<td>&nbsp;<%if(bl.getRtn_cdt().equals("1")){%>원리금균등
						<%}else if(bl.getRtn_cdt().equals("2")){%>원금균등 <%}%>
					</td>
					<td class='title'>상환방법</td>
					<td colspan='3'>&nbsp;<%if(bl.getRtn_way().equals("1")){%>자동이체
										<%}else if(bl.getRtn_way().equals("2")){%>지로
										<%}else if(bl.getRtn_way().equals("3")){%>기타 <%}%>
					</td>
                </tr>
                <tr>
                	<td class='title'>수수료</td>
                	<td>&nbsp;<%=Util.parseDecimal(bl.getCharge_amt())%>원</td>
                	<td class='title'>공증료</td>
                	<td>&nbsp;<%=Util.parseDecimal(bl.getNtrl_fee())%>원</td>
                	<td class='title'>인지대</td>
                	<td colspan='5'>&nbsp;<%=Util.parseDecimal(bl.getStp_fee())%>원</td>
                </tr>
                <tr>
                	<td class='title'>채권확보유형</td>
                	<td colspan='9'>&nbsp;<%if(bl.getBond_get_st().equals("1")){%>계약서
										<%} else if(bl.getBond_get_st().equals("2")){%>계약서+인감증명서
										<%} else if(bl.getBond_get_st().equals("3")){%>계약서+인감증명서+공증서
										<%} else if(bl.getBond_get_st().equals("4")){%>계약서+인감증명서+공증서+LOAN 연대보증서계약자
										<%} else if(bl.getBond_get_st().equals("5")){%>계약서+인감증명서+공증서+LOAN 연대보증서보증인
										<%} else if(bl.getBond_get_st().equals("6")){%>계약서+연대보증인<%}%>
                	</td>
                </tr>                    
            </table>
        </td>
    </tr>
    <tr>
    	<td><계약조건></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td  width='100' class=title>선이자율</td>
                    <td width='400'>&nbsp;<%=bl.getF_rat()%>(%)</td>
                    <td width='100' class=title>조건</td>
                    <td width='400'>&nbsp;<%=bl.getCondi()%></td>
                    
                </tr>
                <tr>
                    <td class=title>대출신청시<br>준비서류</td>
                    <td colspan=3>&nbsp;<%=Util.htmlBR(bl.getDocs())%></td>
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
    	<td></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=800>
            	<tr>
                    <td width='100' class=title>약정금액</td>
                    <td width='150'>&nbsp;<%=Util.parseDecimal(bl.getPm_amt())%>원</td>
                    <td width='150' class=title>대출승인금액</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bl.getLend_a_amt())%>원</td>
                    <td width='100' class=title>약정잔액</td>
                    <td width='200'>&nbsp;<%=Util.parseDecimal(bl.getPm_rest_amt())%>원</td>
                </tr>
            </table>
         </td>
    </tr>
    <tr>
    	<td align="right">
    	<a href="javascript:mapping_list()"  onMouseOver="window.status=''; return true">은행별할부 리스트</a>
<% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>    	&nbsp;|&nbsp;<a href="javascript:reg_cont()"  onMouseOver="window.status=''; return true">대출별등록</a></td>
<%	}
%>
    </tr>
</table>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td colspan='2' width='820'><은행대출담당자></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width='150' class=title>담당자</td>
                    <td width='150' class=title>직위</td>
                    <td width='150' class=title>연락처</td>
                    <td width='350' class=title>담당자이메일</td>
                </tr>
<%
	if(agnt_size > 0)
	{
		for(int i = 0 ; i < agnt_size ; i++)
		{
			BankAgntBean agnt = (BankAgntBean)agnts.elementAt(i);
%>
                <tr>
                	<td align='center'><%=agnt.getBa_nm()%></td>
                	<td align='center'><%=agnt.getBa_title()%></td>
                	<td align='center'><%=agnt.getBa_tel()%></td>
                	<td align='center'><%=agnt.getBa_email()%></td>
                </tr>
<%		}
	}else{
%>
					<td colspan='4'>등록된 담당자가 없습니다</td>
<%	}
%>
            </table>
        </td>	
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>