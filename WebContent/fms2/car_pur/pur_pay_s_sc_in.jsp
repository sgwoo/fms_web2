<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	
	Vector vt = d_db.getCarPurPayDocList(s_kd, t_wd, gubun1, gubun2, "Y", st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
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
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post' action='pur_pay_sc_in.jsp'>
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_pay_frame.jsp'>
  <input type='hidden' name='doc_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='2040'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='460' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='460'>
					<tr><td width='30' rowspan='2'  class='title'  style='height:51'>연번</td>
		            <td width="100" rowspan='2'  class='title'>고객</td>
		            <td width='100' rowspan='2'  class='title'>차종</td>		
		            <td width='100' rowspan='2' class='title'>출고예정일</td>		
		            <td width='90' rowspan='2'  class='title'>구매가격</td>		
		            <td width='40' rowspan='2' class='title'>과세<br>구분</td>	
				</tr>
			</table>
		</td>
		<td class='line' width='1580'>
			<table border="0" cellspacing="1" cellpadding="0" width='1580'>
				<tr>
       		      <td colspan="4" class='title'>구매자금대출</td>	
       		      <td colspan="4" class='title'>구매자금지출</td>					
				  <td colspan="4" class='title'>선불카드</td>				  
				  <td colspan="4" class='title'>신용카드결재내역</td>
			      <td width='100' rowspan='2' class='title'>비고</td>									  				  
			    </tr>
			    
				<tr>
				  <td width='90' class='title'>예정금액</td>
				  <td width='90' class='title'>대출일자</td>
				  <td width='90' class='title'>대출금액</td>		
				  <td width='100' class='title'>시행처</td>
				  
				  <td width='90' class='title'>예정금액</td>
				  <td width='90' class='title'>지출일자</td>
				  <td width='90' class='title'>지출금액</td>		
				  <td width='100' class='title'>지출처</td>
				 
				  <td width='90' class='title'>우리</td>				  				  
			      <td width='90' class='title'>신한</td>
			      <td width='90' class='title'>삼성</td>
				  <td width='100' class='title'>소계</td>
				  				  		  				  
				  <td width='90' class='title'>현대카드</td>
				  <td width='90' class='title'>엘지카드</td>				  
				  <td width='90' class='title'>씨티 외</td>
				  <td width='100' class='title'>소계</td>				  
				
					  				  
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='460' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='460'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
				<!--    <td  width='100' align='center'><a href="javascript:parent.view_pur_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td> -->
					<td  width='100'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"></a></td>
					<td  width='100'>&nbsp<%=ht.get("CAR_NM")%></td>
					<td  width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></td>
				   	<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
				    <td  width='40' align='center'><%=ht.get("PURC_GU")%></td>
				</tr>
<%
		}
%>
                <tr>
                  <td colspan="6" class=title>합계</td>
                </tr>		
			</table>
		</td>
		<td class='line' width='1580'>
			<table border="0" cellspacing="1" cellpadding="0" width='1580'>
<%		for(int i = 0 ; i < vt_size ; i++){
			
			
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<td  width='90' align='right'></td>
					<td  width='90' align='center'></td>
					<td  width='90' align='right'></td>
					<td  width='100' align='center'></td>
						
					<td  width='90' align='right'></td>
					<td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT1")))%></td>
					<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
				    <td  width='100'>&nbsp;<span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></td>	
				    
				   <!-- 선불카드 --> 
<%
				    long card_amt1 = 0;
					long card_amt2 = 0;
					long card_amt3 = 0;
					long card_amt4 = 0;
					long card_amt5 = 0;
					long card_amt6 = 0; 
					
					if ( !ht.get("TRF_ST1").equals("현금") ) {
						if ( ht.get("CARD_KIND1").equals("우리BC카드") ) {  
							card_amt1 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}else if ( ht.get("CARD_KIND1").equals("신한카드") ) {  
							card_amt2 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}else if ( ht.get("CARD_KIND1").equals("삼성카드") ) {  
							card_amt3 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}else if ( ht.get("CARD_KIND1").equals("현대카드") ) {  
							card_amt4 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}else if ( ht.get("CARD_KIND1").equals("엘지카드") ) {  
							card_amt5 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}else  {  
							card_amt6 = AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
						}
					}	
							
					if ( !ht.get("TRF_ST2").equals("현금") ) {
						if ( ht.get("CARD_KIND2").equals("우리BC카드") ) {  
							card_amt1 = card_amt1  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}else if ( ht.get("CARD_KIND2").equals("신한카드") ) {  
							card_amt2 = card_amt2  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}else if ( ht.get("CARD_KIND2").equals("삼성카드") ) {  
							card_amt3 = card_amt3  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}else if ( ht.get("CARD_KIND2").equals("현대카드") ) {  
							card_amt4 = card_amt4  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}else if ( ht.get("CARD_KIND2").equals("엘지카드") ) {  
							card_amt5 = card_amt5  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}else  {  
							card_amt6 = card_amt6  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
						}		
					}
					
					if ( !ht.get("TRF_ST3").equals("현금") ) {
						if ( ht.get("CARD_KIND3").equals("우리BC카드") ) {  
							card_amt1 = card_amt1  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}else if ( ht.get("CARD_KIND3").equals("신한카드") ) {  
							card_amt2 = card_amt2  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}else if ( ht.get("CARD_KIND3").equals("삼성카드") ) {  
							card_amt3 = card_amt3  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}else if ( ht.get("CARD_KIND3").equals("현대카드") ) {  
							card_amt4 = card_amt4  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}else if ( ht.get("CARD_KIND3").equals("엘지카드") ) {  
							card_amt5 = card_amt5  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}else  {  
							card_amt6 = card_amt6  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
						}	
					}		
					
					if ( !ht.get("TRF_ST4").equals("현금") ) {
						if ( ht.get("CARD_KIND4").equals("우리BC카드") ) {  
							card_amt1 = card_amt1  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}else if ( ht.get("CARD_KIND4").equals("신한카드") ) {  
							card_amt2 = card_amt2  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}else if ( ht.get("CARD_KIND4").equals("삼성카드") ) {  
							card_amt3 = card_amt3  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}else if ( ht.get("CARD_KIND4").equals("현대카드") ) {  
							card_amt4 = card_amt4  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}else if ( ht.get("CARD_KIND4").equals("엘지카드") ) {  
							card_amt5 = card_amt5  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}else  {  
							card_amt6 = card_amt6  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
						}	
					}		
				
%>				   
				   
				   
				 	<td  width='90' align='right'><%=Util.parseDecimal(card_amt1)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(card_amt2)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(card_amt3)%></td>
					<td  width='100' align='right'><%=Util.parseDecimal(card_amt1+ card_amt2 + card_amt3)%></td>
				   <!-- 후불카드 -->									
					<td  width='90' align='right'><%=Util.parseDecimal(card_amt4)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(card_amt5)%></td>
					<td  width='90' align='right'><%=Util.parseDecimal(card_amt6)%></td>
					<td  width='100' align='right'><%=Util.parseDecimal(card_amt4+ card_amt5 + card_amt6)%></td>
				
					<td  width='100' align='center'>&nbsp;</td>
				</tr>
<%
					total_amt1 	= total_amt1 + card_amt1;
					total_amt2 	= total_amt2 + card_amt2;
					total_amt3 	= total_amt3 + card_amt3;
					total_amt4 	= total_amt4 + card_amt4;
					total_amt5 	= total_amt5 + card_amt5;
					total_amt6 	= total_amt6 + card_amt6;
				
					total_amt9 	= total_amt9 + Long.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					
					total_amt10	= total_amt10 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		}
%>
                <tr>
               
                  <td colspan=2 class=title>&nbsp;</td>
				  <td class=title style='text-align:right;'></td>
				  <td class=title></td>
				  <td colspan=2 class=title></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt10)%></td>
             	  <td class=title></td>
                  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt1)%></td>      
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt1+total_amt2+total_amt3)%></td>
                  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt4)%></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt5)%></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt6)%></td>
				  <td class=title style='text-align:right;'><%=Util.parseDecimal(total_amt4+total_amt5+total_amt6)%></td>
                  <td class=title>&nbsp;</td>
                </tr>			
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='460' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='460'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1580'>
			<table border="0" cellspacing="1" cellpadding="0" width='1580'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>	
</table>
</form>
<script language='javascript'>
<!--
	//parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
