<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>


<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vts = CardDb.getCardDocSearchListScard(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, gubun8, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc, cgs_ok);
	int vt_size = vts.size();
	
	long total_amt = 0;	
	long total_s_amt = 0;	
	long total_v_amt = 0;	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "08");
	
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	

	//카드내용보기
	function CardDocUpd(cardno, buy_id, doc_mng_id, buy_user_id, card_user_id){
		var fm = document.form1;
		if(fm.auth_rw.value == '6' || fm.auth_rw.value == '4'){	
//			if(fm.user_id.value == doc_mng_id || fm.user_id.value == buy_user_id || fm.user_id.value == '000029' || fm.user_id.value == '000003' || fm.user_id.value == '000004' || fm.user_id.value == '000006' || fm.user_id.value == '000005'){		
				fm.cardno.value = cardno;
				fm.buy_id.value = buy_id;	
				fm.card_user_id.value = card_user_id;		
				fm.action = "sc_doc_reg_u.jsp";
				window.open("about:blank", "CardDocView", "left=20, top=50, width=1200, height=800, scrollbars=yes, status=yes");
				fm.target = "CardDocView";
				fm.submit();
//			}else{
//				alert('해당전표의 사용자 혹은 승인자가 아닙니다.');
//			}
		}else{
			fm.cardno.value = cardno;
			fm.buy_id.value = buy_id;
			fm.card_user_id.value = card_user_id;				
			fm.action = "doc_reg_s.jsp";
			window.open("about:blank", "CardDocView", "left=20, top=50, width=1200, height=800, scrollbars=yes, status=yes");
			fm.target = "CardDocView";
			fm.submit();
		//	alert('권한이 없습니다.');
		}		
	}
	
	function cgs_reg(cardno, buy_id){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.buy_id.value = buy_id;		
		fm.action = "./cgs_ok.jsp";	
		window.open("", "cgs_Reg", "left=10, top=20, width=100, height=100, scrollbars=no");
		fm.target = "cgs_Reg";
		fm.submit();
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='idx' value='<%=idx%>'>
	<input type="hidden" name="cardno" value="<%=cardno%>">
	<input type="hidden" name="buy_id" value="<%=buy_id%>">
	<input type="hidden" name="card_user_id" value="">

<table border="0" cellspacing="0" cellpadding="0" width='1750'>
    <tr><td class=line2 colspan=2></td></tr>    
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='37%' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='5%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>		  
                    <td width='5%' class='title'>연번</td>
                    <td width='8%' class='title'>상태</td>			
                    <td width='22%' class='title'>카드번호</td>
                    <td width='10%' class='title'>소유자</td>
                    <td width='10%' class='title'>사용자</td>
                    <td width='12%' class='title'>거래일자</td>
                    <td width='*' class='title'>거래처</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='63%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='6%' class='title'>과세구분</td>			
                    <td width='10%' class='title'>공급가</td>
                    <td width='10%' class='title'>부가세</td>
                    <td width='10%' class='title'>금액</td>						
                    <td width='8%' class='title'>계정과목</td>
                    <td width='*' class='title'>구분</td>
                    <td width='14%' class='title'>사유</td><!-- 추가 -->
                    <td width='6%' class='title'>등록자</td>		
                    <td width='8%' class='title'>등록일자</td>	
                    <td width='6%' class='title'>승인자</td>	
                    <td width='8%' class='title'>승인일자</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='37%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr> 
                    <td width='5%' align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("CARDNO")%><%=ht.get("BUY_ID")%>"></td>
        			<td width='5%' align="center"><%=i+1%></td>
                    <td width='8%' align="center"><%=ht.get("APP_ST")%></td>
                    <td width='22%' align="center"><%=ht.get("CARDNO")%></td>
                    <td width='10%' align="center"><%=Util.subData(String.valueOf(ht.get("OWNER_NM")), 4)%></td>
                    <td width='10%' align="center"><%=Util.subData(String.valueOf(ht.get("USER_NM")), 4)%></td>
                    <td width='12%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></td>
                    <td width='*' align="center"><a href="javascript:CardDocUpd('<%=ht.get("CARDNO")%>','<%=ht.get("BUY_ID")%>','<%=ht.get("DOC_MNG_ID")%>','<%=ht.get("BUY_USER_ID")%>','<%=ht.get("USER_ID")%>')"><span title='<%=ht.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ht.get("VEN_NAME")), 14)%></span></a></td>
                </tr>
          <%}%>
                <tr align="center">
                    <td class="title" colspan='8'>합계</td>
                </tr>		 				  
            </table>
        </td>
	    <td class='line' width='63%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr> 
                    <td width='6%' align="center"><a href="javascript:CardDocHistory('<%=ht.get("VEN_CODE")%>','<%=ht.get("CARDNO")%>','<%=ht.get("BUY_ID")%>')"><%=ht.get("BUY_ST")%></a></td>			
                    <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_S_AMT")))%>원&nbsp;</td>
                    <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_V_AMT")))%>원&nbsp;</td>			
                    <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%>원&nbsp;</td>
                    <td width='8%' align="center"><%=ht.get("ACCT_CODE_NM")%></td>
                    <td width='*' align="center"><%=Util.subData(String.valueOf(ht.get("ACCT_CODE_G_NM"))+""+String.valueOf(ht.get("ACCT_CODE_G2_NM")), 15)%></td>
                    <td width='14%' align="center"><%=Util.subData(String.valueOf(ht.get("ACCT_CODE_G_NM"))+""+String.valueOf(ht.get("ACCT_CODE_G2_NM")), 15)%></td>
                    <td width='6%' align="center"><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>	
                    <td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>						
                    <td width='6%' align="center"><%=c_db.getNameById(String.valueOf(ht.get("APP_ID")),"USER")%></td>			
                    <td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APP_DT")))%></td>	
                </tr>
              <%	total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("BUY_AMT")));
    				total_s_amt = total_s_amt + Long.parseLong(String.valueOf(ht.get("BUY_S_AMT")));
    				total_v_amt = total_v_amt + Long.parseLong(String.valueOf(ht.get("BUY_V_AMT")));
    		  	}%>
                <tr align="center">
                    <td class="title"></td>					  
                    <td style="text-align:right" class="title"><%=Util.parseDecimal(total_s_amt)%>원&nbsp;</td>
                    <td style="text-align:right" class="title"><%=Util.parseDecimal(total_v_amt)%>원&nbsp;</td>
                    <td style="text-align:right" class="title"><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>						
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>			
                    <td class="title"></td>						
                    <td class="title"></td>			
                    <td class="title"></td>						
                </tr>		 				  			
            </table>
	    </td>
    </tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='40%' id='td_con' style='position:relative;'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='60%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
    </tr>
<% 	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
