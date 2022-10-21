<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	chk1 = "3";
	end_dt = "";
	
	Vector vts = CardDb.getCardUseAcctStat2("", s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
	String  acct_code_yn[]   = new String[13];
	for(int i=0; i<13; i++){
		acct_code_yn[i] = "N";
	}
	int count = 0;
	String acct_code = "";
	String acct_code_nm = "";
	
	int h_cnt = vt_size; //현황 출력 영업소 총수
	if(h_cnt > 0 && h_cnt < 5) h_cnt = 5; //기본 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(h_cnt*25)-300;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//카드내용보기
	function CardUseList(acct_code_nm, acct_code){
		var fm = document.form1;
		fm.acct_code_nm.value = acct_code_nm;
		fm.acct_code.value = acct_code;
		fm.action = "card_use_acct_d_sc_in.jsp";
		fm.target = "inner";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='acct_code' value='<%=acct_code%>'>
<input type='hidden' name='acct_code_nm' value='<%=acct_code_nm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='10%' rowspan="2" class='title'>계정과목</td>
                  <td colspan="2" class='title'>합계</td>
                  <td colspan="2" class='title'>영업팀</td>
                  <td colspan="2" class='title'>관리팀</td>
                  <td colspan="2" class='title'>총무팀</td>
                  <td colspan="2" class='title'>임원</td>
                </tr>
                <tr>
                  <td width='8%' class='title'>건수</td>
                  <td width='10%' class='title'>금액</td>
                  <td width='8%' class='title'>건수</td>
                  <td width='10%' class='title'>금액</td>
                  <td width='8%' class='title'>건수</td>
                  <td width='10%' class='title'>금액</td>
                  <td width='8%' class='title'>건수</td>
                  <td width='10%' class='title'>금액</td>
                  <td width='8%' class='title'>건수</td>
                  <td width='10%' class='title'>금액</td>
                </tr>
                <%	int  cnt[]   = new int[5];
        		  	long amt[]   = new long[5];
        			int  t_cnt[] = new int[5];
        		  	long t_amt[] = new long[5];
        			if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
        					Hashtable ht = (Hashtable)vts.elementAt(i);
        					for(int j=0; j<5; j++){
        						cnt[j]  = AddUtil.parseInt(String.valueOf(ht.get("CNT"+j)));
        						amt[j]  = AddUtil.parseLong(String.valueOf(ht.get("AMT"+j)));
        					}
        					for(int j=0; j<5; j++){
        						t_cnt[j] += cnt[j];
        						t_amt[j] += amt[j];
        					}
        					if(i==0){
        						acct_code = String.valueOf(ht.get("ACCT_CODE"));
        						acct_code_nm = String.valueOf(ht.get("ACCT_CODE_NM"));
        					}
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00001")) acct_code_yn[0] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00002")) acct_code_yn[1] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00003")) acct_code_yn[2] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00004")) acct_code_yn[3] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00005")) acct_code_yn[4] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00006")) acct_code_yn[5] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00007")) acct_code_yn[6] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00008")) acct_code_yn[7] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00009")) acct_code_yn[8] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00010")) acct_code_yn[9] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00011")) acct_code_yn[10] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00012")) acct_code_yn[11] = "Y";
        					if(String.valueOf(ht.get("ACCT_CODE")).equals("00013")) acct_code_yn[12] = "Y";
        					%>
                <tr>
                  <td align="center"><a href="javascript:CardUseList('<%=ht.get("ACCT_CODE_NM")%>','<%=ht.get("ACCT_CODE")%>')"><%=ht.get("ACCT_CODE_NM")%></a></td>
                  <td align="right"><%=cnt[0]%>건&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(amt[0])%>원&nbsp;</td>
                  <td align="right"><%=cnt[1]%>건&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(amt[1])%>원&nbsp;</td>
                  <td align="right"><%=cnt[2]%>건&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(amt[2])%>원&nbsp;</td>
                  <td align="right"><%=cnt[3]%>건&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(amt[3])%>원&nbsp;</td>
                  <td align="right"><%=cnt[4]%>건&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(amt[4])%>원&nbsp;</td>
                </tr>
                <%	}%>
                <tr>
                  <td align="center" class=title>합계</td>
                  <%for(int j=0; j<5; j++){%>
                  <td style="text-align:right" class="title"><%=t_cnt[j]%>건&nbsp;</td>
                  <td style="text-align:right" class="title"><%=Util.parseDecimal(t_amt[j])%>원&nbsp;</td>
                  <%}%>
                </tr>
                <%}%>
            </table>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td width="20">&nbsp;</td>
    </tr>	
    <tr> 
        <td height="<%=height%>" colspan="2"><iframe src="card_use_acct_d_sc_in.jsp<%=hidden_value%>&acct_code=<%=acct_code%>&acct_code_nm=<%=acct_code_nm%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>
</table>
</form>
</body>
</html>
