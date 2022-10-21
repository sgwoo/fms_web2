<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = d_db.getCarPurPayDocAutoDocuList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
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
					if(fm.dlv_dt.value == '')				{ alert('출고 출고일자가 없습니다.'); 					return; }
					if(fm.car_amt_dt.value == '')				{ alert('출고 점검일자가 없습니다.'); 					return; }
					if(fm.car_tax_dt.value == '')				{ alert('출고 차량매입세금계산서 작성일자가 없습니다.');		return; }
					if(fm.pur_pay_dt.value == '')				{ alert('출고 지출일자가 없습니다.'); 					return; }
					if(fm.dlv_ext_ven_code.value == '')			{ alert('출고 세금계산서 거래처코드가 없습니다.'); 			return; }
					if(fm.car_off_ven_code.value == '')			{ alert('출고 지출처(영업소) 거래처코드가 없습니다.'); 			return; }
					if(fm.init_reg_dt.value == '')				{ alert('자동차등록되지 않았습니다.'); 					return; }
					<%}else{%>					
					if(fm.dlv_dt[idx].value == '')				{ alert((idx+1)+'번 출고 출고일자가 없습니다.'); 			return; }
					if(fm.car_amt_dt[idx].value == '')			{ alert((idx+1)+'번 출고 점검일자가 없습니다.'); 			return; }
					if(fm.car_tax_dt[idx].value == '')			{ alert((idx+1)+'번 출고 차량매입세금계산서 작성일자가 없습니다.');	return; }
					if(fm.pur_pay_dt[idx].value == '')			{ alert((idx+1)+'번 출고 지출일자가 없습니다.'); 			return; }
					if(fm.dlv_ext_ven_code[idx].value == '')		{ alert((idx+1)+'번 출고 세금계산서 거래처코드가 없습니다.'); 		return; }
					if(fm.car_off_ven_code[idx].value == '')		{ alert((idx+1)+'번 출고 지출처(영업소) 거래처코드가 없습니다.'); 	return; }
					if(fm.init_reg_dt[idx].value == '')			{ alert((idx+1)+'번 자동차등록되지 않았습니다.'); 			return; }
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
		fm.action = 'pur_pay_autodocu_a.jsp';
		fm.submit();
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/common.js"></script>
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
  <table border="0" cellspacing="0" cellpadding="0" width='2620'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='30' rowspan='2' class='title'>연번</td>
				  <td width='30' rowspan='2' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  					
		          <td width='100' rowspan='2' class='title'>계약번호</td>
		          <td width='100' rowspan='2' class='title'>차량번호</td>
		          <td width='100' rowspan='2' class='title'>계출번호</td>				  
		          <td width="200" rowspan='2' class='title'>고객</td>
       		      <td width='100' rowspan='2' class='title'>차종<br>(최초등록일)</td>		
       		      <td width='80' rowspan='2' class='title'>출고일자</td>
       		      <td width='80' rowspan='2' class='title'>점검일자</td>				  
       		      <td colspan="3" class='title'>세금계산서</td>				  				  
       		      <td width='80' rowspan='2' class='title'>최초등록일</td>
       		      <td colspan="2" class='title'>지출처</td>
       		      <td width='80' rowspan='2' class='title'>지출일자</td>
       		      <td width='100' rowspan='2' class='title'>합계</td>					
       		      <td width='80' rowspan='2' class='title'>계약금</td>									  
				  <td colspan="3" class='title'>지출처리예정내역1</td>				  
				  <td colspan="3" class='title'>지출처리예정내역2</td>
				  <td colspan="3" class='title'>지출처리예정내역3</td>
				  <td colspan="3" class='title'>지출처리예정내역4</td>
			    </tr>
				<tr>
				  <td width='40' class='title'>스캔</td>				  
				  <td width='80' class='title'>작성일자</td>				  
				  <td width='160' class='title'>거래처코드</td>
				  <td width='100' class='title'>이름</td>
				  <td width='80' class='title'>거래처코드</td>
				  <td width='90' class='title'>종류</td>				  
				  <td width='80' class='title'>거래처코드</td>
				  <td width='80' class='title'>금액</td>
				  <td width='90' class='title'>종류</td>				  
				  <td width='80' class='title'>거래처코드</td>
				  <td width='80' class='title'>금액</td>
				  <td width='90' class='title'>종류</td>				  
				  <td width='80' class='title'>거래처코드</td>
				  <td width='80' class='title'>금액</td>
				  <td width='90' class='title'>종류</td>				  
				  <td width='80' class='title'>거래처코드</td>
				  <td width='80' class='title'>금액</td>
			  </tr>
<%	if(vt_size > 0)	{%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			
			
		int size = 0;

		String content_code = "LC_SCAN";
		String content_seq  = (String)ht.get("RENT_MNG_ID")+(String)ht.get("RENT_L_CD")+"1";

		Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
		int attach_vt_size = attach_vt.size();

		String file_type1 = "";
		String seq1 = "";
		String file_name1 = "";
		
	
		for(int j=0; j< attach_vt.size(); j++){
			Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
			
			if((content_seq+"10").equals(aht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(aht.get("FILE_NAME"));
				file_type1 = String.valueOf(aht.get("FILE_TYPE"));
				seq1 = String.valueOf(aht.get("SEQ"));
			}
		}
			
			
			%>			
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=i%>"></td>
					<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>					
					<td  width='100' align='center'><%=ht.get("CAR_NO")%></td>					
					<td  width='100' align='center'>[<%=ht.get("CAR_COMP_ID")%>] <%=ht.get("RPT_NO")%></td>
					<td  width='200'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 20)%></span></td>
					<td  width='100' align='center'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span>
					  <br><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>
					  <input type='hidden' name='init_reg_dt' value='<%=ht.get("INIT_REG_DT")%>'>
					</td>
					<td  width='80' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_car_f_amt('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%><%if(String.valueOf(ht.get("DLV_DT")).equals("")){%>미등록<%}%></a><%}%><input type='hidden' name="dlv_dt" value="<%=ht.get("DLV_DT")%>"></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_AMT_DT")))%><input type='hidden' name="car_amt_dt" value="<%=ht.get("CAR_AMT_DT")%>"></td>					
					<td  width='40' align='center'>
	
						<%if(!seq1.equals("")){%>
						<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0>
						<%}else{%>
						-
						<%}%>							
					</td>	
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_TAX_DT")))%><input type='hidden' name="car_tax_dt" value="<%=ht.get("CAR_TAX_DT")%>"></td>									
					<td  width='160' align='center'>
					
					  <%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0018");
      						int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==선택==</option>

                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%>)</option>        						
        				<%	}%>	

			          </select>
			                 
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0002")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0019");
    						int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==선택==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>	
			          </select>
				          						
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0003")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0021");
  							int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==선택==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>
			          </select>
			                 
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0004")||String.valueOf(ht.get("CAR_COMP_ID")).equals("0005")){
						  	CodeBean[] p_codes = c_db.getCodeDlvExt("0020");
							int p_size = p_codes.length;
					  %>
					  [<%=ht.get("DLV_EXT")%>]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
                        <option value="">==선택==</option>
                        <%	for(int k = 0 ; k < p_size ; k++){
        						CodeBean code = p_codes[k];	%>
        				<option value='<%=code.getApp_st()%>' <%if(code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT"))) != -1){%>selected<%}%>><%= code.getEtc()%>(<%= code.getApp_st()%><%//= code.getNm()%><%//=code.getNm().indexOf(String.valueOf(ht.get("DLV_EXT")))%>)</option>        						
        				<%	}%>
						<option value="608949" >대한모터스(부산)(608949)</option>
						<option value="006005" >아주모터스(006005)</option>
						<option value="112700" >GM부평(112700)</option>
						<option value="006132" >에스에스오토(006132)</option>
						<option value="006052" >삼화모터스(006052)</option>						
			          </select>
			          
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0006")){%>
					  [볼보]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>				        
				        <option value="">==선택==</option>
				        <!-- <option value="995591" >볼보 (주)천하자동차(995591)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0011")){%>
					  [폭스바겐]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006282" >폭스바겐 마이스터모터스(006282)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0012")){%>
					  [크라이슬러]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="000911" >크라이슬러(000911)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0018")){%>
					  [아우디]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006306" >아우디 분당(006306)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0025")){%>
					  [혼다]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="104115" >혼다(104115)</option>
				        <option value="006385" >혼다 안호모터스 강남(006385)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0014")){%>
					  [캐딜락/사브]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="104119" >캐딜락/사브(104119)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0007")){%>
					  [도요타]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="005970" >디앤티도요타(005970)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0013")){%>
					  [BMW]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006281" >BMW 코오롱강남(006281)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0021") || String.valueOf(ht.get("CAR_COMP_ID")).equals("0051")){%>
					  [포드]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006386" >포드 프리미어모터스(006386)</option>
				        <option value="028602" >포드 선인자동차(주)(028602)</option>
				        <option value="995726" >포드 해인자동차(주)(995726)</option>
				        <option value="996228" >(주)더파크모터스(996228)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0027")){%>
					  [벤츠]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006326" >벤츠 더클래스도곡동(006326)</option>
				        <option value="996235" >벤츠 한성자동차(996235)</option>		 -->		        
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0033")){%>
					  [닛산]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="006359" >닛산 프리미어오토모빌(주)(006359)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0034")){%>
					  [푸조]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="995512" >푸조 삼선글로벌모터스(995512)</option>
				        <option value="996117" >푸조 (주)한불모터스(996117)</option>			 -->	         
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0044")){%>
					  [렉서스]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="995514" >렉서스 엘앤티렉서스(주)(995514)</option>
				        <option value="108684" >렉서스 센트럴모터스(108684)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0047")){%>
					  [지프]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="995523" >(주)씨엘모터스(995523)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0048")){%>
					  [인피니티]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="995566" >인피니티 프리미어오토(주)(995566)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0049")){%>
					  [랜드로버]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="996007" >케이씨씨오토모빌(주)(996007)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0050")){%>
					  [미니]
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="">==선택==</option>
				        <!-- <option value="995501" >코오롱글로벌(주)서초MINI지점(995501)</option> -->
			          </select>
					  <%}else if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <select name="dlv_ext_cd" <%if(vt_size > 1){%>onchange="javascript:document.form1.dlv_ext_ven_code[<%=i%>].value=this.value;"<%}else{%>onchange="javascript:document.form1.dlv_ext_ven_code.value=this.value;"<%}%>>
				        <option value="996433" >테슬라코리아(996433)</option>
			          </select>			          
					  <%}else{%>
					  <select name="dlv_ext_cd">
				        <option value="" >없음</option>
			          </select>
					  <%}%>	


					  <br><input type='text' name='dlv_ext_ven_code' value='<%=ht.get("DLV_EXT_VEN_CODE")%>' class='default' size='10'>			  
					</td>										
					<td  width='80' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("INIT_REG_DT")))%></td>					
				    <td>&nbsp;<%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('car_off', '<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></a><%}%></td>	
					<td align='center'>
					  <input type='text' name='car_off_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%><input type='hidden' name="pur_pay_dt" value="<%=ht.get("PUR_PAY_DT")%>"></td>					
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>					
					<!--예약금-->
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>
					<!--지출1-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST1")%>', '<%=ht.get("CARD_KIND1")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND1")%></a><%}%></td>
					<td  width='80' align='center'><input type='hidden' name="card_com_ven_code" value="<%=ht.get("COM_CODE")%>">
					  <%if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드")||String.valueOf(ht.get("TRF_ST1")).equals("후불카드")||String.valueOf(ht.get("TRF_ST1")).equals("카드할부")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("COM_CODE1")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("현금")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("대출") && String.valueOf(ht.get("CARD_KIND1")).equals("폭스바겐파이낸셜")){//아우디폭스바겐파이낸셜%>
					  <input type='text' name='trf1_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("대출") && String.valueOf(ht.get("CARD_KIND1")).equals("토요타파이낸셜")){//토요타파이낸셜%>
					  <input type='text' name='trf1_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("대출") && String.valueOf(ht.get("CARD_KIND1")).equals("벤츠파이낸셜")){//벤츠파이낸셜%>
					  <input type='text' name='trf1_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("대출") && String.valueOf(ht.get("CARD_KIND1")).equals("오릭스캐피탈코리아")){//오릭스캐피탈코리아%>
					  <input type='text' name='trf1_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("대출") && String.valueOf(ht.get("CARD_KIND1")).equals("현대캐피탈")){//현대캐피탈%>
					  <input type='text' name='trf1_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("포인트") && !String.valueOf(ht.get("COM_CODE1")).equals("")){%>
					  <input type='text' name='trf1_ven_code' value='<%=ht.get("COM_CODE1")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("포인트") && String.valueOf(ht.get("COM_CODE1")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){//테슬라%>
					  <input type='text' name='trf1_ven_code' value='' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST1")).equals("포인트") && String.valueOf(ht.get("COM_CODE1")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf1_ven_code' value='995581' class='default' size='10'>
					  <%}else{%>
					  <input type='text' name='trf1_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%></td>
					<!--지출2-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST2")%>', '<%=ht.get("CARD_KIND2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND2")%></a><%}%></td>
					<td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드")||String.valueOf(ht.get("TRF_ST2")).equals("후불카드")||String.valueOf(ht.get("TRF_ST2")).equals("카드할부")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("COM_CODE2")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("현금")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("대출") && String.valueOf(ht.get("CARD_KIND2")).equals("폭스바겐파이낸셜")){//아우디폭스바겐파이낸셜%>
					  <input type='text' name='trf2_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("대출") && String.valueOf(ht.get("CARD_KIND2")).equals("토요타파이낸셜")){//토요타파이낸셜%>
					  <input type='text' name='trf2_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("대출") && String.valueOf(ht.get("CARD_KIND2")).equals("벤츠파이낸셜")){//벤츠파이낸셜%>
					  <input type='text' name='trf2_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("대출") && String.valueOf(ht.get("CARD_KIND2")).equals("오릭스캐피탈코리아")){//오릭스캐피탈코리아%>
					  <input type='text' name='trf2_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("대출") && String.valueOf(ht.get("CARD_KIND2")).equals("현대캐피탈")){//현대캐피탈%>
					  <input type='text' name='trf2_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("포인트") && !String.valueOf(ht.get("COM_CODE2")).equals("")){%>
					  <input type='text' name='trf2_ven_code' value='<%=ht.get("COM_CODE2")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("포인트") && String.valueOf(ht.get("COM_CODE2")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf2_ven_code' value='' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST2")).equals("포인트") && String.valueOf(ht.get("COM_CODE2")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf2_ven_code' value='995581' class='default' size='10'>
					  <%}else{%>
					  <input type='text' name='trf2_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%></td>
					<!--지출3-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST3")%>', '<%=ht.get("CARD_KIND3")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND3")%></a><%}%></td>
					<td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드")||String.valueOf(ht.get("TRF_ST3")).equals("후불카드")||String.valueOf(ht.get("TRF_ST3")).equals("카드할부")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("COM_CODE3")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("현금")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("대출") && String.valueOf(ht.get("CARD_KIND3")).equals("폭스바겐파이낸셜")){//아우디폭스바겐파이낸셜%>
					  <input type='text' name='trf3_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("대출") && String.valueOf(ht.get("CARD_KIND3")).equals("토요타파이낸셜")){//토요타파이낸셜%>
					  <input type='text' name='trf3_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("대출") && String.valueOf(ht.get("CARD_KIND3")).equals("벤츠파이낸셜")){//벤츠파이낸셜%>
					  <input type='text' name='trf3_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("대출") && String.valueOf(ht.get("CARD_KIND3")).equals("오릭스캐피탈코리아")){//오릭스캐피탈코리아%>
					  <input type='text' name='trf3_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("대출") && String.valueOf(ht.get("CARD_KIND3")).equals("현대캐피탈")){//현대캐피탈%>
					  <input type='text' name='trf3_ven_code' value='006244' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("포인트") && !String.valueOf(ht.get("COM_CODE3")).equals("")){%>
					  <input type='text' name='trf3_ven_code' value='<%=ht.get("COM_CODE3")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("포인트") && String.valueOf(ht.get("COM_CODE3")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf3_ven_code' value='' class='default' size='10'>					  
					  <%}else if(String.valueOf(ht.get("TRF_ST3")).equals("포인트") && String.valueOf(ht.get("COM_CODE3")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf3_ven_code' value='995581' class='default' size='10'>					  
					  <%}else{%>
					  <input type='text' name='trf3_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%></td>
					<!--지출4-->
					<td  width='90' align='center'><%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_vendor('<%=ht.get("TRF_ST4")%>', '<%=ht.get("CARD_KIND4")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND4")%></a><%}%></td>
				    <td  width='80' align='center'>
					  <%if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드")||String.valueOf(ht.get("TRF_ST4")).equals("후불카드")||String.valueOf(ht.get("TRF_ST4")).equals("카드할부")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("COM_CODE4")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("현금")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("VEN_CODE")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("대출") && String.valueOf(ht.get("CARD_KIND4")).equals("폭스바겐파이낸셜")){//아우디폭스바겐파이낸셜%>
					  <input type='text' name='trf4_ven_code' value='006367' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("대출") && String.valueOf(ht.get("CARD_KIND4")).equals("토요타파이낸셜")){//토요타파이낸셜%>
					  <input type='text' name='trf4_ven_code' value='995546' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("대출") && String.valueOf(ht.get("CARD_KIND4")).equals("벤츠파이낸셜")){//벤츠파이낸셜%>
					  <input type='text' name='trf4_ven_code' value='006341' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("대출") && String.valueOf(ht.get("CARD_KIND4")).equals("오릭스캐피탈코리아")){//오릭스캐피탈코리아%>
					  <input type='text' name='trf4_ven_code' value='996082' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("포인트") && !String.valueOf(ht.get("COM_CODE4")).equals("")){%>
					  <input type='text' name='trf4_ven_code' value='<%=ht.get("COM_CODE4")%>' class='default' size='10'>
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("포인트") && String.valueOf(ht.get("COM_CODE4")).equals("") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf4_ven_code' value='' class='default' size='10'>					  
					  <%}else if(String.valueOf(ht.get("TRF_ST4")).equals("포인트") && String.valueOf(ht.get("COM_CODE4")).equals("") && !String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
					  <input type='text' name='trf4_ven_code' value='995581' class='default' size='10'>					  
					  <%}else{%>
					  <input type='text' name='trf4_ven_code' value='' class='default' size='10'>
					  <%}%>
					</td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT4")))%></td>
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
		<td>
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <%}%>
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
	<tr>
		<td align='center'><hr></td>	
	</tr>		
</table>
[참고] 제조사별 출고지별 네오엠 거래처코드
<table border="1" cellspacing="3" cellpadding="1" width='100%'>
  <tr>
    <td class="title" width='160'>현대자동차</td>
	<td class="title" width='160'>기아자동차</td>
	<td class="title" width='160'>삼성자동차</td>
	<td class="title" width='160'>한국GM/쌍용자동차</td>
	<td class="title">수입자동차</td>
  </tr>
  <tr>
    <td align='center'>울산(000048)<br>
		아산(000055)<br>
		완주(000136)<br>
		전주(006249)<br>
    </td>
	<td align='center'>화성(000052)<br>
		광명(000516)<br>
		광주(000470)<br>
    </td>
	<td align='center'>부산(000053)<br>
		울산(003070)<br>
		화성(001660)<br>
    </td>
	<td align='center'>부평(000047)<br>
		강남(028732)<br>
		평택(000135)<br>
		대한모터스(부산)(608949)<br>
		아주모터스(006005)<br>
		GM부평(112700)<br>
		에스에스오토(006132)<br>
		삼화모터스(006052)
		
    </td>
	<td align='center'>
	<!-- 
	        볼보 (주)천하자동차(995591)<br>
		폭스바겐 마이스터모터스(006282)<br>
		크라이슬러(000911)<br>
		혼다(104115)<br>
		캐딜락/사브(104119)<br>
		디앤티도요타(005970)<br>
		씨앤씨모터스(006031)<br>
		코오롱강남(006281)<br>
		벤츠 더클래스도곡동(006326)<br>		
		벤츠 한성자동차(996235)<br>		
		닛산 프리미어오토모빌(주)(006359)<br>
		아우디 분당(006306)<br>
		혼다 안호모터스 강남(006385)<br>
		렉서스 엘앤티렉서스(주)(995514)<br>
		렉서스 센트럴모터스(108684)<br>		
		포드 프리미어모터스(006386)<br>
		포드 선인자동차(주)(028602)<br>
		포드 해인자동차(주)(995726)<br>
		푸조 삼선글로벌모터스(995512)<br>
		푸조 (주)한불모터스(996117)<br>
		인피니티 프리미어오토(주)(995566)<br>
		지프 (주)씨엘모터스(995523)<br>
		랜드로버 케이씨씨오토모빌(주)(996007)<br>
		코오롱글로벌(주)서초MINI지점(995501)<br>
		(주)더파크모터스(996228)<br>
		 -->
		테슬라코리아(996433)<br>
	</td>
  </tr>
</table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
<%	if(vt_size > 1){
		for(int i = 0 ; i < vt_size ; i++){%>
		
		if(fm.dlv_ext_ven_code[<%=i%>].value == '' && fm.dlv_ext_cd[<%=i%>].options[fm.dlv_ext_cd[<%=i%>].selectedIndex].value != '') fm.dlv_ext_ven_code[<%=i%>].value = fm.dlv_ext_cd[<%=i%>].options[fm.dlv_ext_cd[<%=i%>].selectedIndex].value;
		
<%		}
	}else if(vt_size == 1){%>
	
		if(fm.dlv_ext_ven_code.value == '' && fm.dlv_ext_cd.options[fm.dlv_ext_cd.selectedIndex].value != '') fm.dlv_ext_ven_code.value = fm.dlv_ext_cd.options[fm.dlv_ext_cd.selectedIndex].value;	

<%	}%>	
//-->
</script>
</body>
</html>
