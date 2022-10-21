<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.receive.*"%>
<%@ page import="acar.user_mng.*,   acar.cls.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
//	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
		
		
	//해지정보
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = rc_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  rc_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	//추심정보
	ClsBandBean cls_band = rc_db.getClsBandInfo(rent_mng_id, rent_l_cd);
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
		
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
	
	function save(){
		var fm = document.form1;
				
		if(fm.req_dt.value == '')				{ alert('소송일자를 입력하십시오'); 		fm.req_dt.focus(); 		return;	}
		if (toInt(parseDigit(fm.suit_amt.value)) < 1 )				{ alert('소송금액을 입력하십시오'); 		fm.suit_amt.focus(); 		return;	}
				
		//추심에 등록되었는지 확인 - 반드시 추심에 등록되어야 함.
		<%-- if( <%=cls_band.getSeq()%> < 1 ) { alert('추심등록후 진행하세요!!!'); 		fm.req_dt.focus(); 		return;	} --%>
		
		if(confirm('등록하시겠습니까?')){	
			fm.action='receive_6_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<body leftmargin="15">
<form name='form1' method='post' >
<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name='cmd' value=''>


<table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지기본사항</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                              
                    <td width='12%' class='title' height="91">계약번호</td>
                    <td height="17%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>담당자</td>
                    <td height="25%">&nbsp;영업담당 : <%=c_db.getNameById((String)fee_base.get("BUS_ID2"),"USER")%> 
                      / 관리담당 : <%=c_db.getNameById((String)fee_base.get("MNG_ID"),"USER")%></td>
                    <td width='12%' class='title'>대여방식</td>
                    <td width='21%'>&nbsp; <%=fee_base.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>고객명</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>대여차명</td>
                    <td>&nbsp;<%=fee_base.get("CAR_NM")%>&nbsp;<%=fee_base.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2((String)fee_base.get("INIT_REG_DT"))%></td>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(start_dt)%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                   <td class='title' height="91">해지구분</td>
                    <td >&nbsp;<%=cls_info.getCls_st()%> </td>                    
                    <td class='title'>해지일</td>
                    <td>&nbsp;<%=cls_info.getCls_dt()%>&nbsp;&nbsp; <font color="#000099"> (경과기일:  <%=days%>일  ) </font></td>
                    <td class='title'>실이용기간</td>
                    <td>&nbsp;<%=cls_info.getRcon_mon()%>개월&nbsp;<%=cls_info.getRcon_day()%>일</td>
              
                </tr>          
                <tr> 
                    <td class='title' style='height:40'>해지내역 </td>
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       
    <tr></tr><tr></tr><tr></tr>  	  
    
    <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>소송내역</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	     <tr>
		                    <td width="13%" class=title>소송일자</td>
		                    <td colspan=3>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                <tr> 
	                    <td class=title width=9%>소송종류</td>
	                    <td colspan=3 >&nbsp;
	                    <input type="radio" name="s_type" value="1" >분쟁조정심의위원회
						<input type="radio" name="s_type" value="2" >민사소송
						<input type="radio" name="s_type" value="N" >소송불가
	                    </td>                  
              	  </tr>
              	  <tr>
                     <td class=title>접수일</td>
                     <td >&nbsp;<input type="text" name="suit_dt" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                     <td class=title>접수번호</td>
                     <td>&nbsp;<input type="text" name="suit_no" size="20" class=text  ></td>
                 	</tr>
                   <tr>     
                    <td class=title width=9%>소송금액</td>
                    <td>&nbsp;<input type="text" name="suit_amt"   size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td class=title width=9%>소송비용</td>
                    <td>&nbsp;<input type="text" name="amt1"   size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                  </tr>
	                <tr> 
                    <td class=title> 특이사항</td>
                    <td colspan="3" height="76"> 
                     &nbsp;<textarea name="req_rem" cols="140" rows="3"></textarea>
                    </td>
                   </tr>	                
	            
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	 
        
    <tr>
        <td></td>
    </tr>
		
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
  </table>
	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
