<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");  
	String t_wd 	= request.getParameter("t_wd")==null? "":request.getParameter("t_wd");
		
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");			
		
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
	
		
	int tot_line = 0;	
	long total_amt 	= 0;
	long total_tax 	= 0;
	long real_amt 	= 0;
	long total_real_amt 	= 0;	
		
	//다중선택된 거래처
	String all_cid 	= request.getParameter("all_cid")==null?"":request.getParameter("all_cid");
			
	String cvalue[] = new String[50];
	StringTokenizer cst = new StringTokenizer(all_cid,",");
	int cs=0; 
	while(cst.hasMoreTokens()){
		cvalue[cs] = cst.nextToken();
		cs++;
	}
	
	String value0[]  = new String[50];  //incom_dt     
	String value1[]  = new String[50];  //incom_seq 
		    		
    String incom_in = "";
    		    		
	for(int ii = 0; ii < cs; ii++){
					
		StringTokenizer st1 = new StringTokenizer(cvalue[ii],"^");
		
		int s1=0; 
							
		while(st1.hasMoreTokens()){
				value0[ii] = st1.nextToken();
				value1[ii] = st1.nextToken();
				if ( ii == 0 ) {
					incom_in =  incom_in + " ( incom_dt = '"+value0[ii]+"' and incom_seq = "+value1[ii] + ")" ;
				} else {
					incom_in =  incom_in + "  or ( incom_dt = '"+value0[ii]+"' and incom_seq = "+value1[ii] + ")";				
				}				 
		}						
	}							
		
	System.out.println("card incom_in 2="+ incom_in);
	
	//카드청구원장
	Vector grt_scds = new Vector();
	
	//연체횟수
	int dly_mon = 0;
			
	if (!all_cid.equals("") ) {
	//스케줄
		 grt_scds = in_db.getScdCardClientList(incom_in);	   
    }
    
    int scd_size= 0; //total
    
    int grt_size = grt_scds.size(); //카드
  				
	if(s_cnt.equals("") || s_cnt.equals("0")){
		if(dly_mon > 15) 		s_cnt=String.valueOf(dly_mon);
		else					s_cnt="15";
	}
			
	dly_mon = AddUtil.parseInt(s_cnt); // 대여료 부분
 
 	
	scd_size = grt_size ;
	
		//입금거래내역 정보
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
	long ip_amt = base.getIncom_amt();	
	String jung_type = base.getJung_type();	
	String ip_method = base.getIp_method();
		
	String value[] = new String[2];
	StringTokenizer st = new StringTokenizer(base.getBank_nm(),":");
	int s=0; 
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search_client();
	}	

	//고객 조회
	function search_client()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/s_card_cont.jsp?s_cnt="+fm.s_cnt.value+"&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&incom_amt=<%=incom_amt%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp", "CLIENT", "left=10, top=10, width=600, height=300, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function cal_rc_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));  //구좌 입금액
		var t_pay_amt 	= 0;
		
		var est_amt = 0;
		
		if ( scd_size < 2  ) {
			est_amt = toInt(parseDigit(fm.est_amt.value));
			
			if(rc_amt < est_amt){
					fm.pay_amt.value = parseDecimal(rc_amt);
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}else{
					fm.pay_amt.value = parseDecimal(est_amt);
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}			
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		
		} else {
		
			for(var i = 0 ; i < scd_size ; i ++){
	
				est_amt = toInt(parseDigit(fm.est_amt[i].value));
				
				
				if(rc_amt < est_amt){
					fm.pay_amt[i].value = parseDecimal(rc_amt);
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}else{
					fm.pay_amt[i].value = parseDecimal(est_amt);
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}			
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}
			
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
		
	}
	
	function cal_rest(){
		var fm = document.form1;
		 
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));
		var t_pay_amt 	= 0;
   
       
		if ( scd_size < 2  ) {
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		} else {
			 for(var i = 0 ; i < scd_size ; i ++){
		 
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));		
			
			}
		}	
		
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
	}	
	
	function save()
	{
		var fm = document.form1;
				
		if(fm.not_yet.checked == true){ 		//미확인입금
		
		} else {
		    //카드인 경우 
			if(toInt(parseDigit(fm.incom_amt.value)) < toInt(parseDigit(fm.t_pay_amt.value)) )
			{
				alert('입금액을 확인하세요');
				return;
			}
		}
		
		if(confirm('입금처리하시겠습니까?'))
		{		
			fm.target = 'i_no';
			//if(fm.user_id.value=='000063') fm.target = '_blank';
			fm.action = 'incom_reg_card_step2_a.jsp'
			fm.submit();
		}		
	}	
	
	//목록
	function del_incom()
	{
		var fm = document.form1;
							
		if(confirm('삭제처리하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_del_a.jsp'
			fm.submit();
		}	
	}
	
	//목록
	function go_to_list()
	{
		var fm = document.form1;
		fm.action = "./incom_r_frame.jsp";
		fm.target = 'd_content';
		fm.submit();
	}
		
	//해지정산 상세내역
	function detail_list(seq, rent_mng_id, rent_l_cd, incom_amt)
	{
		fm = document.form1;			
					
		window.open("/fms2/account/cls_sub_list.jsp?seq="+seq+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&incom_amt="+incom_amt, "de_list", "left=10, top=10, width=500, height=480, scrollbars=yes, status=yes, resizable=yes");
	}	
		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" >
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp">
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  <input type="hidden" name="client_id" >
  <input type='hidden' name='scd_size' value='<%=scd_size%>'>
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>   
   <input type='hidden' name='ip_method' 	value='<%=base.getIp_method()%>'>
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	 
  	<tr> 
 		 <td align=right>
 		 &nbsp; <input type='text' name='s_cnt' size='2' value='<%=s_cnt%>' class='text'>건 
 		 <a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
 		   <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
 		 <% if ( jung_type.equals("0") || jung_type.equals("2") ) { %>&nbsp;<a href="javascript:del_incom()"><img src="/acar/images/center/button_delete.gif" align=absmiddle border="0"></a><% } %>
 		 <% } %>
 		 &nbsp;<a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif" align=absmiddle border="0"></a></td>
    </tr> 	
    
    <tr></tr><tr></tr><tr></tr>
      
    <tr id=tr_acct1 style="display:<%if( base.getJung_type().equals("2") ){%>none<%}else{%>''<%}%>"> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		<tr>  
		         <td class=title width=13%>가수금</td>
		         <td>&nbsp;<input type="checkbox" name="not_yet" value="1" >미확인입금
			  	</td>
			  	<td class=title width=13%>내용</td>
            	<td>&nbsp;<input type='text' name='not_yet_reason' size='100' class='text' value=""></td>
			</tr>
		</table>
	  </td>		  	
	</tr>	 
	
	<tr>
	  <td><hr></td>
	</tr>	
				
    <tr> 
        <td align="right">&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;(입금예정일, 계약일자순) </td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>연번</td>
                    <td class="title" width='16%'>카드사</td>
                    <td class="title" width='12%'>카드번호</td>
                    <td class="title" width='16%'>내용</td>					
                    <td class="title" width='8%'>청구일</td>
                    <td class="title" width='12%'>청구금액</td>					
                    <td class="title" width='9%'>수수료</td>
                    <td class="title" width='11%'>입금예정금액</td>
                    <td class="title" width='11%'>입금처리금액</td>
                  
                </tr>
                
				<%	if(grt_size > 0){
						for(int i = 0 ; i < grt_size ; i++){
							Hashtable grt_scd = (Hashtable)grt_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(grt_scd.get("INCOM_AMT")));
							total_tax 	= total_tax + Long.parseLong(String.valueOf(grt_scd.get("CARD_TAX")));
							real_amt = Long.parseLong(String.valueOf(grt_scd.get("INCOM_AMT"))) - Long.parseLong(String.valueOf(grt_scd.get("CARD_TAX")));
							total_real_amt = total_real_amt + real_amt;
																				
							scd_size++;
				%>
				<input type='hidden' name='gubun' value='scd_card'>
				<input type='hidden' name='card_dt' value='<%=grt_scd.get("INCOM_DT")%>'>
				<input type='hidden' name='card_seq' value='<%=grt_scd.get("INCOM_SEQ")%>'>
				<input type='hidden' name='card_amt' value='<%=grt_scd.get("INCOM_AMT")%>'>
				<input type='hidden' name='card_tax' value='<%=grt_scd.get("CARD_TAX")%>'>
				<input type='hidden' name='card_nm' value='<%=grt_scd.get("CARD_NM")%>'>
				<input type='hidden' name='card_no' value='<%=grt_scd.get("CARD_NO")%>'>
				<input type='hidden' name='card_remark' value='<%=grt_scd.get("CARD_DOC_CONT")%>'>
										
                <tr>
                	<td align="center"><%=i+1%></td>	
                    <td align="center"><%=grt_scd.get("CARD_NM")%></td>		
					<td align="center"><%=grt_scd.get("CARD_NO")%></td>
                    <td align="center"><%=grt_scd.get("CARD_DOC_CONT")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("INCOM_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(grt_scd.get("INCOM_AMT")))%>원</td>					
                    <td align="right"><%=Util.parseDecimal(String.valueOf(grt_scd.get("CARD_TAX")))%>원</td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(real_amt)%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                   
                </tr>							
				<%		}
					}%>		
			
			    <tr>
                    <td colspan="5" class=title>합계</td>
                    <td class=title><%=Util.parseDecimal(total_amt)%>원</td>
                    <td class=title><%=Util.parseDecimal(total_tax)%>원</td>
                    <td class=title><input type='text' name='t_est_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(total_real_amt)%>'>원</td>
                    <td class=title><input type='text' name='t_pay_amt' size='10' class='fixnum' value=''>원</td>
                  
                </tr>																																				
                <tr>
                    <td colspan="7" class=title>잔액</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' name='t_jan_amt' size='10' class='fixnum' value=''>원</td>
                  
                </tr>																																				
            </table>
        </td>
    </tr>	
          		    
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) ){%>

    <tr>
		<td align="right">		
		 <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	
		</td>
	</tr>	
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
