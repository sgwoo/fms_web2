<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.doc_settle.*, acar.car_sche.*, acar.consignment.*, card.*, acar.insur.*, acar.pay_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String m_doc_code = request.getParameter("m_doc_code")==null?"":request.getParameter("m_doc_code");
	String seq1 	= request.getParameter("seq1")==null?"":request.getParameter("seq1");
	String seq2 	= request.getParameter("seq2")==null?"":request.getParameter("seq2");
	String buy_user_id = request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String mode   	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")){ 	user_id = ck_acar_id; }
	if(br_id.equals("")){	br_id 	= acar_br; }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "18"); }
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//변경내용
	InsurChangeBean cng_doc = ins_db.getInsChangeDoc(m_doc_code, "3");
	
	if(!m_doc_code.equals("") && doc_no.equals("")){
		doc = d_db.getDocSettleCommi("33", m_doc_code);
		doc_no = doc.getDoc_no();
	}
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//탁송의뢰
	ConsignmentBean b_cons = new ConsignmentBean();
	
	//카드정보
	CardDocBean cd_bean = new CardDocBean();
	
	//출금원장
	PayMngBean pay 	=  new PayMngBean();
	
	//출금원장
	PayMngBean item	=  new PayMngBean();
	
	int m_amt = 0;
	
	if(st.equals("cons")){
		b_cons = cs_db.getConsignment(seq1, AddUtil.parseInt(seq2));
		m_amt = b_cons.getOil_amt();
	}else if(st.equals("card")){
		cd_bean = CardDb.getCardDoc(seq1, seq2);
		m_amt = cd_bean.getBuy_amt();
	}else if(st.equals("pay")){
		pay 	= pm_db.getPay(seq1);
		item	= pm_db.getPayItem(seq1, AddUtil.parseInt(seq2));
		m_amt = (int)item.getI_amt();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'cons_oil_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;		
		<%if(!doc.getUser_dt1().equals("")){%>
		if(doc_bit == '2'){
			if(fm.ins_doc_st.value == ''){ alert('처리구분을 선택하십시오.'); return; }	
		}		
		<%}else{%>
		if(fm.cng_etc.value == ''){ alert('사유 및 특이사항을 입력하세요'); return;}
		<%}%>
		if(confirm('결재하시겠습니까?')){	
			fm.action='cons_oil_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	//기각일대 사유보이기
	function display_reject(){
		var fm = document.form1;
		
		if(fm.ins_doc_st.value =='N'){ //기각
			tr_reject.style.display	= '';
		}else{							//승인
			tr_reject.style.display	= 'none';
		}
	}	
	
	function cons_view(){
		var fm = document.form1;
		fm.cons_no.value = '<%=seq1%>';
		fm.from_page.value = '/fms2/consignment_new/cons_oil_doc_frame.jsp';
		fm.action='cons_reg_step4.jsp';		
		fm.target='_blank';
		fm.submit();
	}
	
	function card_view(){
		var fm = document.form1;
		fm.cardno.value = '<%=seq1%>';
		fm.buy_id.value = '<%=seq2%>';
		fm.from_page.value = '/fms2/consignment_new/cons_oil_doc_frame.jsp';
		fm.action='/card/doc_mng/doc_reg_u.jsp';		
		fm.target='_blank';
		fm.submit();
	}	
		
	function pay_view(){
		var fm = document.form1;
		fm.reqseq.value = '<%=seq1%>';
		fm.i_seq.value = '<%=seq2%>';
		fm.from_page.value = '/fms2/consignment_new/cons_oil_doc_frame.jsp';
		fm.action='/fms2/pay/pay_upd_step2_in.jsp';		
		fm.target='_blank';
		fm.submit();
	}				
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='cons_oil_doc_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
  <input type='hidden' name='st' 		value='<%=st%>'>
  <input type='hidden' name='m_doc_code' value='<%=m_doc_code%>'>
  <input type='hidden' name='seq1' 		value='<%=seq1%>'>
  <input type='hidden' name='seq2' 		value='<%=seq2%>'>
  <input type='hidden' name='buy_user_id' value='<%=buy_user_id%>'>
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>      
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>        
  <input type='hidden' name='cons_no' 	value=''>        
  <input type='hidden' name='cardno' 	value=''>        
  <input type='hidden' name='buy_id' 	value=''>        
  <input type='hidden' name='reqseq' 	value=''>        
  <input type='hidden' name='i_seq' 	value=''>        
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자문서 > 문서기안 > <span class=style5>예비차유류대경감</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>
	<%if(st.equals("cons")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>구분</td>
                    <td colspan='7'>&nbsp;탁송</td>
                </tr>	            
                <tr> 
                    <td width='10%' class='title'>탁송번호</td>
                    <td width='15%'>&nbsp;<%=b_cons.getCons_no()%>&nbsp;<a href="javascript:cons_view()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td width='10%' class='title'>탁송업체</td>
                    <td width='15%'>&nbsp;<%=b_cons.getOff_nm()%></td>
                    <td width='10%' class='title'>차량번호</td>
                    <td width='15%'>&nbsp;<%=b_cons.getCar_no()%><input type='hidden' name='cont' value='<%=b_cons.getCar_no()%> <%=b_cons.getOff_nm()%> <%=c_db.getNameById(b_cons.getReq_id(),"USER")%>'></td>
                    <td width='10%' class='title'>차명</td>
                    <td width='15%'>&nbsp;<%=b_cons.getCar_nm()%></td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>의뢰자</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameById(b_cons.getReq_id(),"USER")%></td>
                    <td width='10%' class='title'>탁송사유</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameByIdCode("0015", "", b_cons.getCons_cau())%></td>
                    <td width='10%' class='title'>운전자</td>
                    <td colspan='3'>&nbsp;<%=b_cons.getDriver_nm()%> <%=b_cons.getDriver_m_tel()%></td>
                </tr>			
                <tr> 
                    <td width='10%' class='title'>출발</td>
                    <td colspan='3'>&nbsp;
        			    <%if(b_cons.getFrom_st().equals("1")){%>[아마존카]<%}%>
        			    <%if(b_cons.getFrom_st().equals("2")){%>[고객]<%}%>
        			    <%if(b_cons.getFrom_st().equals("3")){%>[협력업체]<%}%>
						<%=AddUtil.ChangeDate3(b_cons.getFrom_dt())%>
						<br>&nbsp;
						<%=b_cons.getFrom_comp()%> - <%=b_cons.getFrom_place()%>
					</td>
                    <td width='10%' class='title'>도착</td>
                    <td colspan='3'>&nbsp;
        			    <%if(b_cons.getTo_st().equals("1")){%>[아마존카]<%}%>
        			    <%if(b_cons.getTo_st().equals("2")){%>[고객]<%}%>
        			    <%if(b_cons.getTo_st().equals("3")){%>[협력업체]<%}%>
						<%=AddUtil.ChangeDate3(b_cons.getTo_dt())%>
						<br>&nbsp;
						<%=b_cons.getTo_comp()%> - <%=b_cons.getTo_place()%>
					</td>
                </tr>	
                <tr> 
                    <td width='10%' class='title'>기타</td>
                    <td colspan='7'>&nbsp;<%=b_cons.getEtc()%></td>
                </tr>	
    		<tr>
        	    <td class='title'>주유요청</td>
        	    <td colspan="7">&nbsp;        			  
        			  <%if(b_cons.getOil_yn().equals("Y")){%>요청
        			  &nbsp;
        			  주유요청시 -&gt; 
        			  <%=Util.parseDecimal(b_cons.getOil_liter())%>리터
        			  혹은
        			  <%=Util.parseDecimal(b_cons.getOil_est_amt())%>원어치 주유 해주세요.        			  
        			  <%}%>
        			  <%if(b_cons.getOil_yn().equals("N")){%>없음<%}%>          			  
        	    </td>
    	        </tr>                												
            </table>
	    </td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        		    <td width="10%" class='title'>탁송료</td>
        	        <td width="10%" class='title'>유류비</td>
        		    <td width="10%" class='title'>세차비</td>
					<td width="10%" class='title'>하이패스등록</td>
        		    <td width="10%" class='title'>기타금액</td>
        		    <td width="10%" class='title'>합계</td>
        		    <td width="40%" class='title'>기타내용</td>
    		    </tr>
    		    <tr>
        		    <td align="right"><%=AddUtil.parseDecimal(b_cons.getCons_amt())%>원</td>
        		    <td align="right"><font color=red><%=AddUtil.parseDecimal(b_cons.getOil_amt())%>원</font></td>
        		    <td align="right"><%=AddUtil.parseDecimal(b_cons.getWash_amt())%>원</td>
					<td align="right"><%=AddUtil.parseDecimal(b_cons.getHipass_amt())%>원</td>
        		    <td align="right"><%=AddUtil.parseDecimal(b_cons.getOther_amt())%>원</td>
        		    <td align="right"><%=AddUtil.parseDecimal(b_cons.getTot_amt())%>원</td>
        		    <td align="center"><%=AddUtil.parseDecimal(b_cons.getOther())%>원</td>
    		    </tr>				
    		</table>
	    </td>
    </tr>			
	<%}else if(st.equals("card")){%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='10%' class='title'>구분</td>
                    <td colspan='7'>&nbsp;카드</td>
                </tr>	                        
                <tr> 
                    <td width='10%' class='title'>카드번호</td>
                    <td width='15%'>&nbsp;<%=cd_bean.getCardno()%>&nbsp;<a href="javascript:card_view()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td width='10%' class='title'>거래일자</td>
                    <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%></td>
                    <td width='10%' class='title'>거래처</td>
                    <td width='15%'>&nbsp;<%=cd_bean.getVen_name()%></td>
                    <td width='10%' class='title'>거래금액</td>
                    <td width='15%'>&nbsp;<font color=red><%=Util.parseDecimal(cd_bean.getBuy_amt())%>원</font></td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>사용자</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%></td>
                    <td width='10%' class='title'>사용구분</td>
                    <td width='15%'>&nbsp;
		              <%if(cd_bean.getAcct_code_g().equals("13")){%>가솔린<%}%>
					  <%if(cd_bean.getAcct_code_g().equals("4")){%>디젤<%}%>
					  <%if(cd_bean.getAcct_code_g().equals("5")){%>LPG<%}%>
					  <%if(cd_bean.getAcct_code_g().equals("27")){%>전기/수소<%}%>	<!-- 전기차충전 추가 -->						
					</td>
                    <td width='10%' class='title'>사용용도</td>
                    <td width='15%'>&nbsp;
					  <%if(cd_bean.getAcct_code_g2().equals("11")){%>업무<%}%>
					  <%if(cd_bean.getAcct_code_g2().equals("12")){%>예비차 보충<%}%>
					  <%if(cd_bean.getAcct_code_g2().equals("13")){%>고객차량<%}%>					
					</td>
                    <td width='10%' class='title'>사용사유</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameByIdCode("0015", "", cd_bean.getO_cau())%></td>
                </tr>			
                <tr> 
                    <td width='10%' class='title'>적요</td>
                    <td colspan='7'>&nbsp;<%=cd_bean.getAcct_cont()%><input type='hidden' name='cont' value='<%=cd_bean.getAcct_cont()%>'></td>
                </tr>							
            </table>
	    </td>
    </tr>	
	<%}else if(st.equals("pay")){%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='10%' class='title'>구분</td>
                    <td colspan='7'>&nbsp;출금</td>
                </tr>	                        
                <tr> 
                    <td width='10%' class='title'>원장번호</td>
                    <td width='15%'>&nbsp;<%=pay.getReqseq()%>-<%=item.getI_seq()%>&nbsp;<a href="javascript:pay_view()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td width='10%' class='title'>거래일자</td>
                    <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(pay.getP_pay_dt())%></td>
                    <td width='10%' class='title'>거래처</td>
                    <td width='15%'>&nbsp;<%=pay.getOff_nm()%></td>
                    <td width='10%' class='title'>거래금액</td>
                    <td width='15%'>&nbsp;<font color=red><%=AddUtil.parseDecimalLong(item.getI_amt())%>원</font></td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>사용자</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameById(item.getBuy_user_id(), "USER")%></td>
                    <td width='10%' class='title'>사용구분</td>
                    <td width='15%'>&nbsp;
		              <%if(item.getAcct_code_g().equals("13")){%>가솔린<%}%>
					  <%if(item.getAcct_code_g().equals("4")){%>디젤<%}%>
					  <%if(item.getAcct_code_g().equals("5")){%>LPG<%}%>
					  <%if(item.getAcct_code_g().equals("27")){%>전기/수소<%}%>	<!-- 전기차충전 추가 -->						
					</td>
                    <td width='10%' class='title'>사용용도</td>
                    <td width='15%'>&nbsp;
					  <%if(item.getAcct_code_g2().equals("11")){%>업무<%}%>
					  <%if(item.getAcct_code_g2().equals("12")){%>예비차 보충<%}%>
					  <%if(item.getAcct_code_g2().equals("13")){%>고객차량<%}%>					
					</td>
                    <td width='10%' class='title'>사용사유</td>
                    <td width='15%'>&nbsp;<%=c_db.getNameByIdCode("0015", "", item.getO_cau())%></td>
                </tr>			
                <tr> 
                    <td width='10%' class='title'>적요</td>
                    <td colspan='7'>&nbsp;<%=item.getP_cont()%><input type='hidden' name='cont' value='<%=item.getP_cont()%>'></td>
                </tr>							
            </table>
	    </td>
    </tr>		
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>경감요청</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>요청일자</td>
                    <td>&nbsp;<%if(doc.getDoc_no().equals("")){ cng_doc.setCh_dt(AddUtil.getDate(4)); }%>
        			  <input type='text' name='cng_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'></td>
                </tr>			
                <tr> 
                    <td width='13%' class='title'>경감금액</td>
                    <td>&nbsp;<%if(doc.getDoc_no().equals("")){ cng_doc.setD_fee_amt(m_amt); }%>
        			  <input type='text' name='d_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getD_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>원</td>
                </tr>			
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea> 
                    </td>
                </tr>
				<%if(!doc.getUser_dt1().equals("")){%>		
                <tr> 
                    <td class='title' width="13%">처리구분</td>
                    <td>&nbsp;
                      <select name='ins_doc_st'  class='default' <%if(!doc.getUser_dt1().equals("")){%>onchange="javascript:display_reject();"<%}%> <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">선택</option>
						<option value="Y" <%if(cng_doc.getIns_doc_st().equals("Y")){%>selected<%}%>>승인</option>
						<option value="N" <%if(cng_doc.getIns_doc_st().equals("N")){%>selected<%}%>>기각</option>
                      </select>
					</td>
                </tr>				
                <tr id=tr_reject style='display:<%if(cng_doc.getIns_doc_st().equals("N")){%>""<%}else{%>none<%}%>'> 
                    <td class='title' width="13%">기각사유</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=cng_doc.getReject_cau()%></textarea></td>
                </tr>								
				<%}else{%>			
				<input type='hidden' name='ins_doc_st' value=''>        
				<input type='hidden' name='reject_cau' value=''>        
				<%}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%//=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%//=doc.getUser_nm4()%></td>
                    <td class=title width=12%><%//=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
					  <!--기안자-->
					  <%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        			  <%if(doc.getUser_dt1().equals("")){
        			  		String user_id1 = doc.getUser_id1();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id1);
        					if(!cs_bean.getWork_id().equals("")){		user_id1 = cs_bean.getWork_id(); }
        					%>
        			  <%	if(user_id1.equals(user_id) || buy_user_id.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			    <a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					</td>
                    <td align="center">
					  <!--영업팀장-->
					  <%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getWork_id().equals("")){		user_id2 = cs_bean.getWork_id(); }
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	 
	<%if(!mode.equals("view")){%> 		
		
	<%		if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
	<tr>
	    <td class=h></td>
	</tr>		
    <tr>
		<td align="right">
		  <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
		  <%	if(!doc.getDoc_step().equals("3") || nm_db.getWorkAuthUser("전산팀",user_id)){%> 	
		  &nbsp;
		  <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		  <%	}%>	
		</td>
	</tr>	
	<%		}%>
	<%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
