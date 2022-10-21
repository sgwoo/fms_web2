<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*, acar.con_ins.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
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
	int incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
	
		
	int tot_line = 0;	
	long total_amt 	= 0;
	long total_tax 	= 0;
	long real_amt 	= 0;
	long total_real_amt 	= 0;	
	
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
	
	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"cls":request.getParameter("gubun");
	int total_su = 0;
		
	Vector inss = ai_db.getInsIncomPayList(f_list, br_id, "", "6", "3", gubun4, st_dt, end_dt, s_kd, t_wd, "6", asc, gubun);
	int ins_size = inss.size();
	
	int scd_size = 0;
	
	scd_size = ins_size;
	
	String ven_code = "";
	String ven_name = "";
	
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
					
		window.open("/fms2/account/s_cont.jsp?s_cnt="+fm.s_cnt.value+"&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&incom_amt=<%=incom_amt%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp", "CLIENT", "left=10, top=10, width=600, height=300, scrollbars=yes, status=yes, resizable=yes");
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
		
			if(toInt(parseDigit(fm.incom_amt.value)) != toInt(parseDigit(fm.t_pay_amt.value)) )
			{
				alert('입금액을 확인하세요');
				return;
			}
			
			if ( fm.n_ven_code.value == "" ) {
				 alert('거래처를 선택하셔야 합니다.');
			     return;
			}		
		}
		
		if(confirm('입금처리하시겠습니까?'))
		{		
			fm.target = 'i_no';
			//if(fm.user_id.value=='000063') fm.target = '_blank';
			fm.action = 'incom_reg_ins_step2_a.jsp'
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
			
	//거래처조회하기
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.n_ven_name.value != ''){	fm.t_wd.value = fm.n_ven_name.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.n_ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=700, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
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
  <input type="hidden" name="t_wd" value="">  
    
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	 
  	<tr> 
 		 <td align=right>
 		 &nbsp; <input type='text' name='s_cnt' size='2' value='<%=s_cnt%>' class='text'>건 
 	
 		 <% if ( jung_type.equals("0") || jung_type.equals("2") ) { %>&nbsp;<a href="javascript:del_incom()"><img src="/acar/images/center/button_delete.gif" align=absmiddle border="0"></a><% } %>
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
	
	<tr><td>&nbsp;</td></tr>
     
    <tr>
        <td class=line2></td>
    </tr>
    
    <tr>
	      <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	      
	          <tr> 
	            <td class=title width=13%>거래처</td>
	            <td >&nbsp;
	            	<input name="n_ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">				
			       
					<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 				
				&nbsp;&nbsp;&nbsp;* 네오엠코드 : &nbsp;	        
				<input type="text" readonly name="n_ven_code" value="<%=ven_code%>" class='whitetext' >
				<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;
					
				</td>
	          </tr>	
	      	    
	        </table>
		  </td>		   
    </tr>	  	    
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>연번</td>
                 	<td class="title" width='4%'>구분</td>
                    <td class="title" width='10%'>계약번호</td>
                    <td class="title" width='11%'>차량번호</td>
                    <td class="title" width='16%'>차명</td>					
                    <td class="title" width='8%'>보험사</td>
                    <td class="title" width='8%'>보험계약일</td>					
                    <td class="title" width='8%'>해지발생일</td>
                    <td class="title" width='8%'>청구일</td>
                    <td class="title" width='9%'>환급예정금액</td>
                    <td class="title" width='9%'>입금처리금액</td>                  
                </tr>
                
				<%	if(ins_size > 0){
					for(int i = 0 ; i < ins_size ; i++){
							Hashtable ins = (Hashtable)inss.elementAt(i); 
							total_amt 	= total_amt + Long.parseLong(String.valueOf(ins.get("PAY_AMT")));																					
							scd_size++;
				%>
				<input type='hidden' name='gubun' value='scd_ins'>
				<input type='hidden' name='rent_l_cd' value='<%=ins.get("RENT_L_CD")%>'>
				<input type='hidden' name='car_mng_id' value='<%=ins.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='ins_st' value='<%=ins.get("INS_ST")%>'>
				<input type='hidden' name='ins_tm' value='<%=ins.get("INS_TM")%>'>
				<input type='hidden' name='car_no' value='<%=ins.get("CAR_NO")%>'>
				<input type='hidden' name='ins_com_id' value='<%=ins.get("INS_COM_ID")%>'>
				<input type='hidden' name='ins_tm2' value='<%=ins.get("INS_TM2")%>'>
				<input type='hidden' name='car_use' value='<%=ins.get("CAR_USE")%>'>
													
                <tr>
                	<td align="center"><%=i+1%></td>
                	<td align="center"><%=ins.get("INS_TM2_NM")%></td>	
                    <td align="center"><%=ins.get("RENT_L_CD")%></td>		
					<td align="center"><%=ins.get("CAR_NO")%></td>
                    <td align="center"><%=Util.subData(String.valueOf(ins.get("CAR_NM"))+" "+String.valueOf(ins.get("CAR_NAME")), 14)%></td>		
                    <td align="center"><%=ins.get("INS_COM_NM")%></td>			
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("R_INS_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                   
                </tr>							
				<%		}
					}%>		
			
			    <tr>
                    <td colspan="9" class=title>합계</td>
                    <td class=title><input type='text' name='t_est_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt)%>'>원</td>
                    <td class=title><input type='text' name='t_pay_amt' size='10' class='fixnum' value=''>원</td>
                  
                </tr>	
                 <tr>
                    <td colspan="9" class=title>잔액</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' name='t_jan_amt' size='10' class='fixnum' value=''>원</td>
                  
                </tr>																																				
                																																		
            </table>
        </td>
    </tr>	
          		    
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) || nm_db.getWorkAuthUser("대전출납",user_id) || nm_db.getWorkAuthUser("보험업무",user_id ) || nm_db.getWorkAuthUser("부산차량등록자",user_id)   ){%>

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
