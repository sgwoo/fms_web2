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
	
	Vector vt = d_db.getCarPurPayDocAutoDocuAcList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	
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
	
	//네오엠 코드 등록
	function update_vendor(st, nm){
		window.open("/acar/car_office/car_office_i.jsp?auth_rw=6&user_id=<%=user_id%>&br_id=<%=br_id%>&st="+st+"&car_off_id="+nm, "CAR_F_AMT", "left=10, top=10, width=920, height=350, scrollbars=yes, status=yes, resizable=yes");		
	}
	//자동차출고가격 
	function update_car_f_amt(rent_mng_id, rent_l_cd){
		window.open("/acar/car_register/register_pur_id.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd, "CAR_F_AMT", "left=10, top=10, width=820, height=1000, scrollbars=yes, status=yes, resizable=yes");
	}
	
		
	//등록하기
	function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					var idx = parseInt(idnum.substr(21),10);
					<%if(vt_size == 1){%>
					if(fm.ac_neoe_yn.value != '2'){	
						if(fm.sh_base_dt1.value == '')			{ alert('매매금액 거래일자가 없습니다.'); 						return; }
						if(fm.ven_code1.value == '')				{ alert('매매금액 거래처코드가 없습니다.');						return; }
					}
					if(fm.ac_neoe_yn.value != '1'){
						if(fm.sh_base_dt2.value == '')			{ alert('중개수수료 거래일자가 없습니다.'); 					return; }
						if(fm.ven_code2.value == '')				{ alert('중개수수료 거래처코드가 없습니다.'); 				return; }
						if(fm.trf_amt3.value != '0' && fm.trf_amt3.value != 'null' && fm.sh_base_dt3.value == '') {alert('보관료 거래일자가 없습니다.'); return;}
					}
					<%}else{%>					
					if(fm.ac_neoe_yn[idx].value != '2'){		
						if(fm.sh_base_dt1[idx].value == '')	{ alert((idx+1)+'번 출고 매매금액 거래일자가 없습니다.'); 		return; }
						if(fm.ven_code1[idx].value == '')		{ alert((idx+1)+'번 출고 매매금액 거래처코드가 없습니다.');		return; }
					}
					if(fm.ac_neoe_yn[idx].value != '1'){
						if(fm.sh_base_dt2[idx].value == '')	{ alert((idx+1)+'번 출고 중개수수료 거래일자가 없습니다.'); 	return; }
						if(fm.ven_code2[idx].value == '')		{ alert((idx+1)+'번 출고 중개수수료 거래처코드가 없습니다.'); 	return; }
						if(fm.trf_amt3[idx].value != '0' && fm.trf_amt3[idx].value != 'null' && fm.sh_base_dt3[idx].value == '') {alert((idx+1)+'번 보관료 거래일자가 없습니다.'); return;}
					}
					<%}%>
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("일괄 처리할 건을 선택하세요.");
			return;
		}	
				
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'pur_pay_autodocu_ac_a.jsp';
		fm.submit();
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body">
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
  <table border="0" cellspacing="0" cellpadding="0" width='1780'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='30' rowspan='2' class='title'>연번</td>
				  <td width='30' rowspan='2' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		          <td width='100' rowspan='2' class='title'>전표발행</td>
		          <td width='100' rowspan='2' class='title'>계약번호</td>
		          <td width='100' rowspan='2' class='title'>차량번호</td>
       		    <td width='100' rowspan='2' class='title'>차종</td>		
       		    <td width='100' rowspan='2' class='title'>최초등록일</td>
       		    <td width='100' rowspan='2' class='title'>지출일자</td>
				      <td colspan="4" class='title'>지출처리예정내역-매매금액</td>
				      <td colspan="4" class='title'>지출처리예정내역-중개수수료</td>
				      <td colspan="3" class='title'>지출처리예정내역-보관료</td>
			    </tr>
				<tr>
				  <td width='100' class='title'>계산서일자</td>
				  <td width='100' class='title'>상호</td>
				  <td width='100' class='title'>거래처코드</td>
				  <td width='100' class='title'>금액</td>
				  
				  <td width='100' class='title'>계산서일자</td>
				  <td width='100' class='title'>상호</td>
				  <td width='100' class='title'>거래처코드</td>
				  <td width='100' class='title'>금액</td>

          <td width='100' class='title'>계산서일자</td>
				  <td width='100' class='title'>상호</td>
				  <td width='100' class='title'>금액</td>

			  </tr>
<%	if(vt_size > 0)	{%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=i%>"></td>
					<td  width='100' align='center'>
					  <select name='ac_neoe_yn' class='default'>
              <option value=''>모두</option>
						  <option value='1' <%if(String.valueOf(ht.get("TRF_AMT2")).equals("0")){%>selected<%}%>>매매금액</option>
						  <option value='2'>중개수수료+보관료</option>
            </select>
					</td>
					<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
					<td  width='100' align='center'><%=ht.get("EST_CAR_NO")%></td>
					<td  width='100' align='center'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
					<td  width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SH_INIT_REG_DT")))%></td>
					<td  width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%></td>
					<!--지출1-->
					<td  width='100' align='center'><input type='text' size='12' name='sh_base_dt1' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SH_BASE_DT2")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td  width='100' align='center'><%=ht.get("CAR_OFF_NM2")%></td>
					<td  width='100' align='center'><input type='text' name='ven_code1' value='<%=ht.get("VEN_CODE2")%>' class='default' size='8'></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%><input type='hidden' name="trf_amt1" value="<%=ht.get("TRF_AMT1")%>"></td>
					<!--지출2-->
					<td  width='100' align='center'><input type='text' size='12' name='sh_base_dt2' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SH_BASE_DT1")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td  width='100' align='center'><%=ht.get("CAR_OFF_NM1")%></td>
					<td  width='100' align='center'><input type='text' name='ven_code2' value='<%=ht.get("VEN_CODE1")%>' class='default' size='8'></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%><input type='hidden' name="trf_amt2" value="<%=ht.get("TRF_AMT2")%>"></td>
					<!--지출3-->
					<td  width='100' align='center'><input type='text' size='12' name='sh_base_dt3' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SH_BASE_DT3")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td  width='100' align='center'><%=ht.get("CAR_OFF_NM1")%></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%><input type='hidden' name="trf_amt3" value="<%=ht.get("TRF_AMT3")%>"></td>
				</tr>
<%		}%>
<%	}%>	
			</table>
		</td>
  	</tr>
	<tr>
		<td align='center'>&nbsp;</td>	
	</tr>	
	<tr>
		<td align='center'>
		  <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <%}%>
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
