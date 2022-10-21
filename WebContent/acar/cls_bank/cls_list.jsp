<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	BankLendBean bl = abl_db.getBankLend(lend_id);
	
	Vector vt =  as_db.getClsBankList(lend_id);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//중도해지
	function view_cls_list(cls_rtn_dt){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var rtn_seq = fm.rtn_seq.value;
		var url = "";
		url = "../cls_bank/cls_c.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&cls_rtn_dt="+cls_rtn_dt;
		window.open(url, "CLS_BANK", "left=100, top=180, width=940, height=550, status=yes, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>

<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=980>
    <tr> 
      <td> 
        <table border="0" cellspacing="1" cellpadding="0" width=980>
          <tr> 
            <td align='left'><font color="navy">재무관리 -> 은행대출관리</font> -> <font color="red">은행대출 
              중도상환 이력</font></td>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class='line2' > 
        <table border="0" cellspacing="1" cellpadding="0" width=980>
          <tr> 
            <td width='90' class='title'>은행대출ID</td>
            <td width='110'>&nbsp;<%=lend_id%></td>
            <td width='80' class='title'>금융사구분</td>
            <td width='130'>&nbsp;
			  <%if(bl.getCont_bn_st().equals("1")){%>제1금융권<%}%>
              <%if(bl.getCont_bn_st().equals("2")){%>제2금융권<%}%>
            </td>
            <td width='80' class='title'>금융사</td>
            <td width="110">&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
            <td class='title' width="80">지점명</td>
            <td>&nbsp;<%=bl.getBn_br()%></td>
          </tr>
          <tr> 
            <td class='title' width="90">계약일</td>
            <td>&nbsp;<%=bl.getCont_dt()%></td>
            <td class='title' width="80">이자율</td>
            <td>&nbsp;<%=bl.getLend_int()%>%</td>
            <td class='title' width="80">대출금액</td>
            <td colspan='3'>&nbsp;<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>원</td>
          </tr>
                <tr> 
                    <td class=title width=10%>중도상환<br>수수료율</td>
                    <td width=15%>&nbsp;<%=bl.getCls_rtn_fee_int()%>%</td>
                    <td class=title wwidth=10%>중도상환<br>특이사항</td>
                    <td colspan='5'>&nbsp;<%=bl.getCls_rtn_etc()%></td>                    
                </tr>			  
        </table>
      </td>
    </tr>
    <tr> 
      <td>&lt;&lt; 대출 중도상환 내역 &gt;&gt;</td>
    </tr>
    <tr> 
      <td class='line2'> 
        <table border="0" cellspacing="1" cellpadding="0" width="980">
          <tr> 
            <td width='30' class='title'>연번</td>
            <td width='90' class='title'>해지일</td>
            <td width='150' class='title'>해지사유</td>			
            <td width='100' class='title'>미상환원금</td>
            <td width='100' class='title'>유동성장기부채</td>
            <td width='90' class='title'>장기차입금</td>
            <td width='80' class='title'>해지수수료</td>			
            <td width='80' class='title'>기타수수료</td>
            <td width='80' class='title'>경과이자</td>
            <td width='80' class='title'>기타금액</td>			
            <td width='100' class='title'>상환금액</td>						
          </tr>
		  <%	for(int i = 0 ; i < vt_size ; i++){
				ClsBankBean cls = (ClsBankBean)vt.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:view_cls_list('<%=cls.getCls_rtn_dt()%>');" title='중도상환 보기'><%=cls.getCls_rtn_dt()%></a></td>
            <td>&nbsp;<%=cls.getCls_rtn_cau()%></td>
            <td	align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest_1())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest_2())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_etc_fee())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getDly_alt()+cls.getBe_alt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%></td>
          </tr>				
		  <%	}%>		
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
