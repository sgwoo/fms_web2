<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.ars_card.*"%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	out.println("미사용페이지입니다.");
	if(1==1)return;
	
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
	
	
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//결제연동 기발행건이 있는지 확인한다.
	Hashtable ht_ax = rs_db.getAxHubCase(ars_code, "", ars.getGood_mny());
	
	
	String am_ax_code = String.valueOf(ht_ax.get("AM_AX_CODE"))==null?"":String.valueOf(ht_ax.get("AM_AX_CODE"));
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
			fm.action='ars_req_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}			
	}

	
	//카드결제연동번호발송
	function ax_hub_orderno_send(){
		var fm = document.form1;
		window.open("about:blank", "AX_HUB_ORDER_SEND", "left=100, top=10, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'AX_HUB_ORDER_SEND';
		fm.action = 'ax_hub_order_send.jsp';
		fm.submit();			
	}	
	
	//금액셋팅
	function set_amt(st){
		var fm = document.form1;	
		//채권금액
		if(st==1){
			//20170825 3.7->3.2 카드수수료 변경	
			fm.card_fee.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.settle_mny.value)) * 3.2 /100 ) );
		}
		
		fm.good_mny.value 	= parseDecimal(toInt(parseDigit(fm.settle_mny.value)) + toInt(parseDigit(fm.card_fee.value)) );						
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
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>결제정보</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
               <tr> 
                    <td class=title width=10%>등록</td>
                    <td>&nbsp;<font color=red>
                        <%=ars.getReg_dt()%></font>&nbsp;<%=c_db.getNameById(ars.getReg_id(),"USER")%>
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>계약자명</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_name' size='30' value='<%=ars.getBuyr_name()%>' class='text'></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>휴대폰번호</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_tel2' size='30' value='<%=ars.getBuyr_tel2()%>' class='text'>(문자발송)</td>
                </tr>								
                <tr> 
                    <td class=title width=10%>메일주소</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_mail' size='30' value='<%=ars.getBuyr_mail()%>' class='text' style='IME-MODE: inactive'>(신용카드매출전표발송))</td>
                </tr>								
                <tr> 
                    <td class=title width=10%>차량번호</td>
                    <td>&nbsp;
                        <input type='text' name='good_name' size='30' value='<%=ars.getGood_name()%>' class='text' style='IME-MODE: active'></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>내역</td>
                    <td>&nbsp;
                        <textarea name='msg' rows='5' cols='90' class='text' style='IME-MODE: active'><%=ars.getGood_cont()%></textarea>                        
                    </td>
                </tr>		                						
                <tr> 
                    <td class=title width=10%>채권금액</td>
                    <td>&nbsp;
                        <input type='text' name='settle_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getSettle_mny())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt(1);'>원
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>카드수수료</td>
                    <td>&nbsp;
                        <input type='text' name='card_fee' size='10' value='<%=AddUtil.parseDecimal(ars.getCard_fee())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_amt(2);'>원
                        &nbsp;(3.2%)
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>카드결재금액</td>
                    <td>&nbsp;
                        <input type='text' name='good_mny' size='10' value='<%=AddUtil.parseDecimal(ars.getGood_mny())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원                        
                        &nbsp;(채권금액+카드수수료)
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=10%>카드사</td>
                    <td>&nbsp;
                        <select name="card_kind">
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
                    <td class=title width=10%>카드번호</td>
                    <td>&nbsp;
                        <input type='text' name='card_no' size='30' value='<%=AddUtil.ChangeCard(ars.getCard_no())%>' class='text'></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>유효기간</td>
                    <td>&nbsp;
                        <select name="card_y_mm">
			    <option value="">선택</option>
	          	    <%for(int i=1; i<=12; i++){%>
	          	    <option value="<%=AddUtil.addZero2(i)%>" <%if(ars.getCard_y_mm().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          	    <%}%>
	        	</select> 
                        <select name="card_y_yy">
                            <option value="">선택</option>			    
			    <%for(int i=AddUtil.getDate2(1); i<=(AddUtil.getDate2(1)+10); i++){%>
			    <option value="<%=i%>" <%if(ars.getCard_y_yy().equals(String.valueOf(i))){%>selected<%}%>><%=i%>년</option>
			    <%}%>
			</select>	        			           
                    </td>
                </tr>								
                <tr> 
                    <td class=title width=10%>할부기간</td>
                    <td>&nbsp;
                        <select name="quota">			    
			    <option value="" <%if(ars.getQuota().equals("일시불")){%>selected<%}%>>일시불</option>
	          	    <%for(int i=2; i<=6; i++){%>
	          	    <option value="<%=i%>" <%if(ars.getQuota().equals(String.valueOf(i))){%>selected<%}%>><%=i%>개월</option>
	          	    <%}%>
			</select>                                                                    
                        (무이자는 없음)
                    </td>
                </tr>	
             
                <%if(!ars.getApp_id().equals("")){%>         
                <tr> 
                    <td class=title width=10%>완료</td>
                    <td>&nbsp;
                        <%=ars.getApp_dt()%> <%=c_db.getNameById(ars.getApp_id(),"USER")%>
                    </td>
                </tr>	                           
                <%}else{%>   							
                <tr> 
                    <td class=title width=10%>처리</td>
                    <td>&nbsp;
                        <select name="app_st">			    
	          	    <option value="1">ARS결제</option>
	          	    <!-- <option value="2">온라인결제</option> -->
			</select> 
			<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("법인카드관리자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id) ||  nm_db.getWorkAuthUser("본사출납",user_id) ){%>
			<!-- 
			&nbsp;&nbsp;<a href="javascript:save('msg');">[입금처리요청]</a>
			&nbsp;&nbsp;<a href="javascript:save('app');"><img src=/acar/images/center/button_finish.gif align=absmiddle border=0></a>
			 -->						
			<%		if(String.valueOf(ht_ax.get("ORDR_IDXX")).equals("null") || String.valueOf(ht_ax.get("ORDR_IDXX")).equals("")){%>	
			&nbsp;&nbsp;&nbsp;&nbsp;
			<!-- 
			<a href="javascript:ax_hub_orderno_send();"><img src="/acar/images/center/button_in_nsend.gif" align="absmiddle" border="0" title="결제인증번호발송"></a>
			 -->
			<%		}%>
			<%}%>
                    </td>
                </tr>	                
                <%}%>
    	    </table>
	</td>
    </tr> 	    
    <tr>
        <td class=h></td>
    </tr>
    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <%    //if(ars.getApp_id().equals("")){%>    
    <%	  if(am_ax_code.equals("") || am_ax_code.equals("null")){%>
    <tr>
	<td align="right">		
	    <a href="javascript:save('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>    
	</td>
    </tr>	    
    <%	  }%>
    <%    //}%>
    <%}%>
    
    <tr>
        <td>* 결제가능카드 : BC, 삼성, 신한, 외환, 현대, 롯데카드, 국민카드, 법인공용카드 기명식</td>
    </tr>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
