<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.cls.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//출고전대차기간포함여부
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	int tae_sum = 0;
	if(prv_mon_yn.equals("0")){
		tae_sum = af_db.getTaeCnt(m_id);
	}
	
	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//건별 대여료 스케줄 리스트
	//Vector fee_scd = af_db.getFeeScdPrint(l_cd, "");
	Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);	//2018.04.16
	int fee_scd_size = fee_scd.size();
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "02");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	boolean me_w = nm_db.getWorkAuthUser("회계업무",user_id);
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}
	
	//한회차씩 스케줄 확인
	function tm_update(idx, rent_st, rent_seq, fee_tm, tm_st1, tm_st2){
		var fm = document.form1;
		window.open("about:blank", "SCDUPD", "left=50, top=50, width=700, height=610, scrollbars=yes");				
		fm.idx.value = idx;
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.fee_tm.value = fee_tm;
		fm.tm_st1.value = tm_st1;
		fm.tm_st2.value = tm_st2;
		fm.action = "fee_scd_u_tm2.jsp";
		fm.target = "SCDUPD";
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=fee_scd_size%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
<input type='hidden' name='tae_sum' value='<%=tae_sum%>'>
<input type='hidden' name='idx' value=''>
<input type='hidden' name='tm_st1' value=''>
<input type='hidden' name='tm_st2' value=''>
<input type='hidden' name='fee_tm' value=''>
<input type='hidden' name='rent_seq' value=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='18%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='25%' class='title' style='height:36'>회차</td>
                    <td width='30%' class='title'>구분</td>
                    <td width='45%' class='title'>입금예정일</td>
                </tr>
	        </table>
	    </td>
	    <td class='line' width='82%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='10%' class='title' style='height:36'>공급가</td>
                    <td width='9%' class='title'>부가세</td>
                    <td width='10%' class='title'>월대여료</td>
                    <td width='9%' class='title'>입금일자</td>
                    <td width='10%' class='title'>실입금액</td>
                    <td width='8%' class='title'>연체일수</td>
                    <td width='8%' class='title'>연체료</td>
                    <td width='7%' class='title'>입금취소</td>
                    <td width='11%' class='title'>수정</td>
                    <td width='9%' class='title'>입금예정일<br>변경내역</td>			
                    <td width='9%' class='title'>세금계산서<br>발행일자</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	if(fee_scd_size>0){%>  
    <tr>
	    <td class='line' width='18%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>	  
<%		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>		
				<input type='hidden' name='h_pag_cng_dt' value='<%=a_fee.getPay_cng_dt()%>'>
				<input type='hidden' name='h_pag_cng_cau' value='<%=a_fee.getPay_cng_cau()%>'>
				<input type='hidden' name='ht_tm_st1' value='<%=a_fee.getTm_st1()%>'>				
				<input type='hidden' name='ht_tm_st2' value='<%=a_fee.getTm_st2()%>'>
				<input type='hidden' name='ht_fee_tm' value='<%=a_fee.getFee_tm()%>'>
				<input type='hidden' name='ht_rc_yn' value='<%=a_fee.getRc_yn()%>'>
				<input type='hidden' name='ht_rent_seq' value='<%=a_fee.getRent_seq()%>'>
				<input type='hidden' name='t_tm_st2' value='<%=a_fee.getTm_st2()%>'>
				<tr>
				<%if(a_fee.getRc_yn().equals("0")){ //미입금%>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='25%'><%if(a_fee.getTm_st1().equals("0")){%><a href="javascript:tm_update('<%=i+1%>','<%=a_fee.getRent_st()%>','<%=a_fee.getRent_seq()%>','<%=a_fee.getFee_tm()%>','<%=a_fee.getTm_st1()%>','<%=a_fee.getTm_st2()%>')"><%}%><%if(a_fee.getTm_st2().equals("2"))%><font color=red>b</font><%%><%=a_fee.getFee_tm()%></a></td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='30%'><input type='text' name='t_tm_st1' size='5' class='whitetext' value='<%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%>' readonly></td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='45%'><input type='text' name='t_fee_est_dt' size='11' class='whitetext' value='<%=a_fee.getFee_est_dt()%>' readonly></td>
				<%}else{//입금된것%>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='25%'><%if(a_fee.getTm_st1().equals("0")){%><a href="javascript:tm_update('<%=i+1%>','<%=a_fee.getRent_st()%>','<%=a_fee.getRent_seq()%>','<%=a_fee.getFee_tm()%>','<%=a_fee.getTm_st1()%>','<%=a_fee.getTm_st2()%>')"><%}%><%if(a_fee.getTm_st2().equals("2"))%><font color=red>b</font><%%><%=a_fee.getFee_tm()%></a></td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='30%'><input type='text' name='t_tm_st1' size='5' class='istext' value='<%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%>' readonly></td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='45%'><input type='text' name='t_fee_est_dt' size='11' class='istext' value='<%=a_fee.getFee_est_dt()%>' readonly></td>
				<%}%>
				</tr>
<%		}%>				
	        </table>
	    </td>
	    <td class='line' width='82%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>
                <tr>
				<%if(a_fee.getRc_yn().equals("0")){ //미입금%>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='right'  width='10%'><input type='text' name='t_fee_s_amt' size='8' class='whitenum' value='<%=Util.parseDecimal(a_fee.getFee_s_amt())%>' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='right'  width='9%'><input type='text' name='t_fee_v_amt' size='6' class='whitenum' value='<%=Util.parseDecimal(a_fee.getFee_v_amt())%>' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='right'  width='10%'><input type='text' name='t_fee_amt' size='8' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' maxlength='10' onBlur='javascript:parent.cal_sv_amt(<%=i%>)' class='whitenum' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='9%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<input type='text' name='t_rc_dt' value='' size='11' class='whitenum' readonly>
					<%}else{%>
					<%=cls.getCls_dt()%>
					<%}%>					
					</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='10%'>
					<%if(a_fee.getBill_yn().equals("Y")){%>
					<input type='text' name='t_rc_amt' value='' size='8' class='whitenum' readonly>
					<%}else if(a_fee.getBill_yn().equals("I")){%>
					임의미결
					<%}else{%>
					해지정산
					<%}%>					
					</td>				
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='right' width='8%'><%=a_fee.getDly_days()%>일&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='right' width='8%'><%=Util.parseDecimal(a_fee.getDly_fee())%>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='7%'>
					<!--<%if(a_fee.getBill_yn().equals("Y") && me_w){//입금%>
						<a href="javascript:parent.pay_fee(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ig.gif align=absmiddle border="0"></a>
					<%}else{%>-<%}%>
					-->-
					</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> width='11%' align="center">
					<%if(ck_acar_id.equals("000029")){ %>
					<%	if(a_fee.getBill_yn().equals("Y") && !a_fee.getTm_st1().equals("0")){//잔액삭제%>
					<a href="javascript:parent.ext_scd_j('DROP', <%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border="0"></a>
					<%	} %>
					<%} %>
					<!--
					<%if(me_w){%>
					<%	if(a_fee.getBill_yn().equals("Y")){//수정%>					
						 <a href="javascript:parent.change_scd(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border="0"></a> 
					<%	}%>
					<%	if(!a_fee.getTm_st2().equals("0")){//삭제, 1회차연장대여료 혹은 지연대여료일 경우%>
							<a href="javascript:parent.ext_scd('DROP', <%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border="0"></a> 
					<%	}else{%>
					<%		if(i+1 == fee_scd_size){//삭제, 일반대여료이고 마지막회차일 경우%>
							<a href="javascript:parent.ext_scd('DROP', <%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border="0"></a> 						
					<%		}else{%>
					<%			if(!a_fee.getTm_st1().equals("0")){//삭제, 잔액인경우%>		
							<a href="javascript:parent.ext_scd_j('DROP', <%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border="0"></a> 											
					<%			}%>
					<%		}%>
					<%	}%>
					<%}else{%>-<%}%>
					-->-
					</td>				
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='9%'>
					<%if(a_fee.getPay_cng_dt().equals("--")){%>
						-
					<%}else{%>
						<a href="javascript:parent.view_cng_cau(<%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border="0"></a>
					<%}%>
					</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> align='center' width='9%'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>											
				<%}else{//입금된것%>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right'  width='10%'><input type='text' name='t_fee_s_amt' size='8' class='isnum' value='<%=Util.parseDecimal(a_fee.getFee_s_amt())%>' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right'  width='9%'><input type='text' name='t_fee_v_amt' size='6' class='isnum' value='<%=Util.parseDecimal(a_fee.getFee_v_amt())%>' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right'  width='10%'><input type='text' name='t_fee_amt' size='8' value='<%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>' class='isnum' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='9%'><input type='text' name='t_rc_dt' value='<%=a_fee.getRc_dt()%>' size='11' maxlength='10' class='istext' readonly></td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right'  width='10%'><input type='text' name='t_rc_amt' value='<%=Util.parseDecimal(a_fee.getRc_amt())%>' size='8' class='isnum' readonly>원&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right' width='8%'><%=a_fee.getDly_days()%>일&nbsp;</td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='right' width='8%'><%=Util.parseDecimal(a_fee.getDly_fee())%>원&nbsp;</td>					
		            <td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='7%'>
        		      <%if(me_w && a_fee.getIslast().equals("Y")){//입금취소%>
		              <a href="javascript:parent.cancel_rc(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border="0"></a> 
		              <%}else{%>-<%	}%>
 		            </td>
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='11%'>
					  <!-- 
					  <%if(me_w){//수정%>										
					  <a href="javascript:parent.change_scd(<%=i%>, <%=a_fee.getRent_st()%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border="0"></a> 
					  <%}else{%>-<%}%>
					   -->-
					</td>			
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='9%'>
					<%if(a_fee.getPay_cng_dt().equals("--")){%>
						-
					<%}else{%>
						<a href="javascript:parent.view_cng_cau(<%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border="0"></a><%}%>
					</td>							
					<td <%if(a_fee.getTm_st2().equals("3")){%>class="im"<%}%> class='is' align='center' width='9%'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
				<%}%>
		        </tr>				
<%		}//for end%>
            </table>
	    </td>
    </tr>
<%	}else{%>        
    <tr>
	    <td class='line' width='18%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td align='center'>등록된 데이타가 없습니다</td>
        		</tr>
	        </table>
	    </td>
	    <td class='line' width='82%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    		        <td>&nbsp;</td>
    		    </tr>
    	  </table>
	    </td>
    </tr>
<%	}//if end%>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>

