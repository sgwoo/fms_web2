<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.ars_card.*, acar.doc_settle.*, acar.car_sche.*"%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "05", "12", "26");	
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
		
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
		
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("35", ars_code);
		doc_no = doc.getDoc_no();
	}
	
	if(!doc.getUser_id1().equals("")){
		//영업담당자
		user_bean 	= umd.getUsersBean(doc.getUser_id1());
	}
	
	
	String update_yn = "N";
	if(ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("법인카드관리자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){
    	if(ars.getApp_id().equals("") && doc.getUser_dt1().equals("")){
    		update_yn = "Y";
    	}
    }	
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트
	function list(){
		var fm = document.form1;	
		fm.action = 'ars_card_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//등록
	function save(mode){
		var fm = document.form1;
		
		fm.cng_item.value = mode;
		
		if(confirm('처리 하시겠습니까?')){	
			fm.action='ars_card_req_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}			
	}


	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '1'){
			if(fm.exempt_yn.value == 'Y'){
				if(fm.exempt_cau.value == '')		{ alert('수수료 면제사유를 입력하십시오.'); 			fm.exempt_cau.focus(); 	return; }
			}						
		}
				
		if(confirm('결재하시겠습니까?')){	
			fm.action='ars_card_sanction.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}									
	}	
	
	function Infini_Reg(){
		var fm = document.form1;
		fm.target="i_no";				
		<%if(ck_acar_id.equals("000029")){%>
		if(fm.view_check.checked == true){
			fm.target="_blank";
		}	
		<%}%>
		fm.action = "innopayPg_req.jsp";
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
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='ars_code' 	value='<%=ars_code%>'>
  <input type='hidden' name="cng_item" value="">
  <input type='hidden' name="doc_no" value="<%=doc_no%>">
  <input type='hidden' name="doc_bit" value="">
           
        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>공지사항 > <span class=style5>ARS결제요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>	    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드결제 청구서</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
               <tr> 
                    <td class=title width=10%>관리번호</td>
                    <td>&nbsp;<%=ars_code%></td>
                </tr>	
               <tr> 
                    <td class=title width=10%>등록</td>
                    <td>&nbsp;<font color=red>
                        <%=ars.getReg_dt()%></font>&nbsp;<%=c_db.getNameById(ars.getReg_id(),"USER")%>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>담당자</td>
                    <td>&nbsp;
                        영업담당 : <%=ars.getBus_nm()%> / 회계담당 : <%=ars.getMng_nm()%>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>내역</td>
                    <td>&nbsp;
                        <textarea name='msg' rows='5' cols='90' class='text' style='IME-MODE: active'><%=ars.getGood_cont()%></textarea>                        
                    </td>
                </tr>	                							
    	    </table>
	</td>
    </tr> 	        
    <tr>
        <td class=h></td>
    </tr>                
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>구매자명</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_name' size='60' value='<%=ars.getBuyr_name()%>' class='whitetext' readonly></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>상품명</td>
                    <td>&nbsp;
                        <input type='text' name='good_name' size='60' value='<%=ars.getGood_name()%>' class='text'></td>
                </tr>								
                	                						
                <tr> 
                    <td class=title width=10%>채권금액</td>
                    <td>&nbsp;
                        <input type='text' name='settle_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getSettle_mny())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%> >원
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>카드수수료</td>
                    <td>&nbsp;
                        <input type='text' name='card_fee' size='10' value='<%=AddUtil.parseDecimal(ars.getCard_fee())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%> >원
                        &nbsp;(<input type='text' name='card_per' size='3' value='<%=ars.getCard_per()%>' class='whitetext' style="text-align:right;" readonly>%)
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>카드결재금액</td>
                    <td class=is>&nbsp;
                        <input type='text' name='good_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getGood_mny())%>' <%if(update_yn.equals("Y")){%>class='num'<%}else{%>class='whitenum' readonly<%}%>>원                        
                        &nbsp;<%if(ars.getExempt_yn().equals("Y")){%>(수수료면제)<%}else{%>(채권금액+카드수수료)<%} %>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>휴대폰번호</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_tel2' size='30' value='<%=ars.getBuyr_tel2()%>' class='text'>(문자발송)</td>
                </tr>								
                <tr> 
                    <td class=title width=10%>이메일</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_mail' size='30' value='<%=ars.getBuyr_mail()%>' class='text' style='IME-MODE: inactive'>(신용카드매출전표발송)</td>
                </tr>	
    	    </table>
	</td>
    </tr> 	        
    <tr>
        <td class=h></td>
    </tr>                
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                                
                <%if(ars.getApp_st().equals("1")){%>
                <tr> 
                    <td class=title width=10%>신용카드사</td>
                    <td>&nbsp;
                        <select name="card_kind" disabled>
			    <option value="">선택</option>
			    <option value="BC카드"   <%if(ars.getCard_kind().equals("BC카드")){%>selected<%}%>>BC카드</option>
			    <option value="삼성카드" <%if(ars.getCard_kind().equals("삼성카드")){%>selected<%}%>>삼성카드</option>
			    <option value="신한카드" <%if(ars.getCard_kind().equals("신한카드")){%>selected<%}%>>신한카드</option>			                                
			    <option value="외환카드" <%if(ars.getCard_kind().equals("외환카드")){%>selected<%}%>>외환카드</option>
			    <option value="현대카드" <%if(ars.getCard_kind().equals("현대카드")){%>selected<%}%>>현대카드</option>
			    <option value="롯데카드" <%if(ars.getCard_kind().equals("롯데카드")){%>selected<%}%>>롯데카드</option>
			    <option value="하나SK카드" <%if(ars.getCard_kind().equals("하나SK카드")){%>selected<%}%>>하나SK카드</option>
			    <option value="NH채움카드" <%if(ars.getCard_kind().equals("NH채움카드")){%>selected<%}%>>NH채움카드</option>			    
			    <option value="KB국민카드" <%if(ars.getCard_kind().equals("KB국민카드")){%>selected<%}%>>KB국민카드</option>
			</select>                                                
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>신용카드 번호</td>
                    <td>&nbsp;
                        <%if(!ars.getApp_id().equals("")){%>
                        <input type='hidden' name="card_no" value="<%=ars.getCard_no()%>">
                        <%=AddUtil.ChangeCardStar(ars.getCard_no())%>
                        <%}else{%>
                        <input type='text' name='card_no' size='30' value='<%=AddUtil.ChangeCard(ars.getCard_no())%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >
                        <%}%>
                    </td>
                        
                </tr>								
                <tr> 
                    <td class=title width=10%>카드 유효기간</td>
                    <td>&nbsp;
                        <%if(!ars.getApp_id().equals("")){%>
                        **/**
                        <input type='hidden' name="card_y_mm" value="<%=ars.getCard_y_mm()%>">
                        <input type='hidden' name="card_y_yy" value="<%=ars.getCard_y_yy()%>">
                        <%}else{ %>
                        <input type='text' name='card_y_mm' size='2' value='<%=ars.getCard_y_mm()%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >월
                        /
                        <input type='text' name='card_y_yy' size='4' value='<%=ars.getCard_y_yy()%>' <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id))){%>class='text'<%}else{%>class='whitetext' readonly<%} %> >년
                        <!--
                        <select name="card_y_mm" <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id))){%><%}else{%>disabled<%} %>>
			    			<option value="">선택</option>
	          	    		<%for(int i=1; i<=12; i++){%>
	          	    		<option value="<%=AddUtil.addZero2(i)%>" <%if(ars.getCard_y_mm().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          	    		<%}%>
	        			</select> 
                        <select name="card_y_yy" <%if(ars.getApp_st().equals("1") && (ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id))){%><%}else{%>disabled<%} %>>
                            <option value="">선택</option>			    
			    			<%for(int i=AddUtil.getDate2(1); i<=(AddUtil.getDate2(1)+10); i++){%>
			    			<option value="<%=i%>" <%if(ars.getCard_y_yy().equals(String.valueOf(i))){%>selected<%}%>><%=i%>년</option>
			    			<%}%>
						</select>
						-->	        
			            <%}%>			           
                    </td>
                </tr>								
                <tr> 
                    <td class=title width=10%>할부 기간</td>
                    <td>&nbsp;
                        <select name="quota">			    
			    <option value="" <%if(ars.getQuota().equals("일시불")){%>selected<%}%>>일시불</option>
	          	    <%for(int i=2; i<=6; i++){%>
	          	    <option value="<%=i%>" <%if(ars.getQuota().equals(String.valueOf(i))){%>selected<%}%>><%=i%>개월</option>
	          	    <%}%>
			</select>                                                                    
                    <!--    (무이자는 없음)&nbsp;&nbsp;&nbsp;<a href="http://web.innopay.co.kr/" target=_blank title="카드사별 무이자 할부">[카드사별 무이자 할부 확인]</a> -->
                             (무이자는 없음)&nbsp;&nbsp;&nbsp;* BC카드 3개월까지만 할부 가능 
                    </td>
                </tr>	
                <%} %>                	
                <tr> 
                    <td class=title width=10%>처리</td>
                    <td>&nbsp;
                        <select name="app_st" disabled>		
                        	<option value="3" <%if(ars.getApp_st().equals("3")){%>selected<%}%>>SMS결제(고객)</option>	    
                        	<option value="1" <%if(ars.getApp_st().equals("1")){%>selected<%}%>>ARS결제(아마존카)</option>
						</select> 
						
						<%if(ars.getApp_st().equals("1") && ars.getApp_id().equals("")){%>         
            			<%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id)){%>
            			&nbsp;&nbsp;
						&nbsp;&nbsp;<a href="javascript:save('msg');">[입금처리요청]</a>
						<%	}%>
						<%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("입금담당",ck_acar_id) || nm_db.getWorkAuthUser("출금담당",ck_acar_id)){%>
						&nbsp;&nbsp;<a href="javascript:save('app');"><img src=/acar/images/center/button_finish.gif align=absmiddle border=0></a>												
						<%	}%>
						<%}%>
									
                    </td>
                </tr>	                                
                
                <%if(!ars.getApp_id().equals("")){%>         
                <tr> 
                    <td class=title width=10%>완료</td>
                    <td>&nbsp;
                        <%=ars.getApp_dt()%> <%=c_db.getNameById(ars.getApp_id(),"USER")%>
                        
                        <%if(ars.getCancel_dt().equals("")){%>
                        <%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("법인카드관리자",ck_acar_id) || nm_db.getWorkAuthUser("해지관리자",ck_acar_id)){%>
						&nbsp;&nbsp;<a href="javascript:save('cancel');">[결제후 취소처리]</a>												
						<%	}%>
                        <%} %>     
                    </td>
                </tr>	                           
                <%} %>   		
                
                <%if(!ars.getCancel_dt().equals("")){%>         
                <tr> 
                    <td class=title width=10%>결제후취소일</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate2(ars.getCancel_dt())%>
                    </td>
                </tr>	                           
                <%} %>   	
    	    </table>
	</td>
    </tr> 	        
    <tr>
        <td class=h></td>
    </tr>
    <%if(ars.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("법인카드관리자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
    <%		if(ars.getApp_id().equals("") && doc.getUser_dt1().equals("")){%>
    <tr>
	<td align="right">		
	    <a href="javascript:save('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>    
	</td>
    </tr>	   
    <%	  	}%> 
    <%}%>
    <%	String ars_card_req_yn = "Y";%>
    
    <%	if(ars.getApp_st().equals("1")){
    		ars_card_req_yn = "ars";
    	} 
    %>
    <%if(ars.getExempt_yn().equals("Y")){
    	if(!doc.getDoc_step().equals("3")){
    		ars_card_req_yn = "not settle"; //결재미완
    	}	
    %>               
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> 수수료 면제 (수수료 면제 요청시 담당자-팀장-총무팀장-대표이사 문서결재시스템 처리)</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>    
                <tr> 
                    <td class=title width=10% colspan='3' style="height:30px;">수수료 면제 여부</td>
                    <td>&nbsp;
                        <input type="checkbox" name="w_exempt_yn" value="Y" <%if(ars.getExempt_yn().equals("Y")){%>checked<%}%> disabled> 수수료 면제 한다.
                        <input type='hidden' name='exempt_yn' 	value='<%=ars.getExempt_yn()%>'>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10% colspan='3' style="height:30px;">수수료 면제 사유</td>
                    <td>&nbsp;
                        <textarea name='exempt_cau' rows='5' cols='90' class='text' style='IME-MODE: active'><%=ars.getExempt_cau()%></textarea>
                    </td>
                </tr>	                 
    	    </table>
	</td>
    </tr> 	            
    <tr>
        <td>※ 문서번호 : <%=doc.getDoc_no()%></td>
    </tr>                              
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><!--기안자--><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        			  <%if(doc.getUser_dt1().equals("")){%>
        			    <a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%}%>
                    </td>
                    <td align="center"><!--팀장--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_id2().equals("XXXXXX")){
					    if(!doc.getDoc_step().equals("3") && !doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--총무팀장--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getDoc_step().equals("3") && !doc.getUser_dt1().equals("") && doc.getUser_dt3().equals("")){
        			  		String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id3 = nm_db.getWorkAuthUser("출고관리자");
        					%>
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>
                    <td align="center"><!--대표이사-->-<br>&nbsp;</td>
                    <td align="center">&nbsp;</td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	
	<%} %>
    <tr>
        <td class=h></td>
    </tr>	  
	<%if(ars_card_req_yn.equals("Y")){%>   
	
	<%		if(ars.getApp_id().equals("")){%>       
	<%			if(ars.getArs_step().equals("2")){%>
	<tr>
        <td align="center"><font color='red'>※ 이노페이에 카드결재 요청이 되었습니다. 고객결재 대기중 입니다.</font></td>
    </tr> 
	<%			}else{ %>	
    <tr>
        <td align="center">
            <img src=/acar/images/center/icon_arrow.gif align=absmiddle> 인증방식 : 
            <input type="radio" name="svcPrdtCd" value="04" checked>앱카드(04):카드사 모바일앱 연동
            &nbsp;
            <input type="radio" name="svcPrdtCd" value="03">일반등록(03):카드번호,유효기간,비밀번호 직접입력
            &nbsp;        	
        	<input type="button" class="button" value="신용카드결제청구서 이노페이 등록" onclick="javascript:Infini_Reg();">
        	<%if(ck_acar_id.equals("000029")){%>
        	&nbsp;&nbsp;   
        	<input type="checkbox" name="view_check" value="Y"> 점검
        	<%} %>
        </td>
    </tr>    
    <tr>
        <td align="center"><font color='red'>※ [신용카드결제청구서 이노페이 등록] 클릭하면 이노페이에 카드결재 요청됩니다.</font></td>
    </tr>      	
    <%			} %>
    <%		} %>
    
	<%}else if(ars_card_req_yn.equals("not settle")){ %>
    <tr>
        <td align="center">수수료 면제건 결재가 완료된 후에 신용카드결제청구를 이노페이에 요청할 수 있습니다.</td>
    </tr>    		
	<%} %>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
