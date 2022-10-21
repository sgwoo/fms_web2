<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	
	if(idx.equals("1")) idx = "1_2";
	
	Vector vars = e_db.getCarSubList(idx, car_comp_id, car_cd, car_id, car_seq, a_a);
	int size = vars.size();
	
	if(idx.equals("1_2")) idx = "1";
	
	if(idx.equals("2")||idx.equals("3")){
		//차명정보
		cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
		//차종변수
		ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	}
	
	int count = 0;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title><%=car_nm%> == <%if(idx.equals("1")) {%>차종 <%}else if(idx.equals("2")) {%>옵션 <%}else if(idx.equals("3")) {%>색상 <%}else{%>제조사DC<%}%> 선택</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function setCode(id, seq, nm, amt, s_st, jg_2, jg_opt_st, jg_g_7, jg_tuix_st, jg_w, lkas_yn, ldws_yn, aeb_yn, fcw_yn, hook_yn){
		var fm = opener.document.form1;				
		<%if(idx.equals("1")){%>
		fm.car_name.value = nm;
		fm.car_id.value = id;
		fm.car_seq.value = seq;
		fm.car_amt.value = parseDecimal(amt);		
		fm.a_e.value = s_st;	
		fm.jg_2.value = jg_2;	
		if(jg_2 == '1'){
			fm.est_st.value = '4';
		}else{
			fm.est_st.value = '0';
		}
		fm.jg_g_7.value = jg_g_7;	
		fm.jg_w.value = jg_w;
		fm.opt.value = '';
		fm.opt_seq.value = '';
		fm.opt_amt.value = '0';	
		fm.jg_opt_st.value = '';	
//		fm.col.value = '';
//		fm.in_col.value = '';
//		fm.col_seq.value = '';
//		fm.col_amt.value = '0';		
//		fm.jg_col_st.value = '';			
		fm.dc.value = '';
		fm.dc_seq.value = '';
		fm.dc_amt.value = '0';
		fm.esti_d_etc.value = '';
		fm.ls_yn.value = '';
		fm.dc_amt2.value = '0';
		fm.jg_tuix_st.value = jg_tuix_st;
		fm.jg_tuix_opt_st.value = '';
		fm.lkas_yn.value = lkas_yn;		// 차선이탈 제어형 (차종포함)
		fm.lkas_yn_opt_st.value = '';	// 차선이탈 제어형 (옵션)
		fm.ldws_yn.value = ldws_yn;	// 차선이탈 경고형 (차종포함)
		fm.ldws_yn_opt_st.value = '';	//	차선이탈 경고형 (옵션)
		fm.aeb_yn.value = aeb_yn;		// 긴급제동 제어형 (차종포함)
		fm.aeb_yn_opt_st.value = '';	// 긴급제동 제어형 (옵션)
		fm.fcw_yn.value = fcw_yn;		// 긴급제동 경고형 (차종포함)
		fm.fcw_yn_opt_st.value = '';		// 긴급제동 경고형 (옵션)
		fm.hook_yn.value = hook_yn;		// 견인고리
		fm.hook_yn_opt_st.value = '';		// 견인고리
		opener.compare(fm.car_amt);
		<%}else if(idx.equals("2")){%>
		fm.opt.value = nm;
		fm.opt_seq.value = id;
		fm.opt_amt.value = parseDecimal(amt);
		fm.jg_opt_st.value = jg_opt_st;
		fm.jg_tuix_opt_st.value = jg_tuix_st;
		fm.lkas_yn_opt_st.value = lkas_yn;		// 차선이탈 제어형 (옵션)
		fm.ldws_yn_opt_st.value = ldws_yn;		//	차선이탈 경고형 (옵션)
		fm.aeb_yn_opt_st.value = aeb_yn;		// 긴급제동 제어형 (옵션)
		fm.fcw_yn_opt_st.value = fcw_yn;		// 긴급제동 경고형 (옵션)
		fm.hook_yn_opt_st.value = hook_yn;		// 견인고리 (옵션)
		
		<%}else if(idx.equals("3")){%>
		fm.col.value = nm;
		fm.col_seq.value = id;
		fm.col_amt.value = parseDecimal(amt);
		fm.jg_col_st.value = jg_opt_st;
		<%}else if(idx.equals("4")){%>
		fm.dc.value = nm;
		fm.dc_seq.value = id;
		fm.dc_amt.value = parseDecimal(amt);
		<%}else if(idx.equals("5")){%>
		fm.conti_rat.value = nm;
		fm.conti_rat_seq.value = seq;
		<%}%>
		
		<%if(!idx.equals("5")){%>
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));
		<%}%>
		self.close();
	}
	
	function setDcCode(car_b_dt, car_d, car_d_seq, car_d_per, car_d_p, ls_yn, car_d_per2, car_d_p2, car_d_per_b, car_d_per_b2, esti_d_etc){
		var fm = opener.document.form1;				
		var dc_amt 		= 0;
		var dc_amt2 	= 0;
		var dc 		= "";
		var dc2 	= "";
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) ;
		
		dc_amt 		= (car_price*car_d_per/100)+car_d_p;
		dc 				= "("+car_d_per+"%+"+parseDecimal(car_d_p)+")";
		
		if(car_d_per_b == '2'){
			dc_amt 	= ((car_price-car_d_p)*car_d_per/100)+car_d_p;
			dc 	    = "(반영후"+car_d_per+"%+"+parseDecimal(car_d_p)+")";
		}
		
		if(ls_yn == 'Y'){
			dc_amt2 = (car_price*car_d_per2/100)+car_d_p2;
			dc2     = "("+car_d_per2+"%+"+parseDecimal(car_d_p2)+")";
			if(car_d_per_b2 == '2'){
				dc_amt2 = ((car_price-car_d_p2)*car_d_per2/100)+car_d_p2;
				dc2     = "(반영후"+car_d_per2+"%+"+parseDecimal(car_d_p2)+")";
			}
		}else{
			dc_amt2 = dc_amt;
			dc2     = dc;
		}
		
		if(dc_amt == 0) 	dc = "";
		if(dc_amt2 == 0) 	dc2 = "";
		
		fm.dc.value 			= dc;
		fm.dc_seq.value 	= car_b_dt+''+car_d_seq;
		fm.dc_amt.value 	= parseDecimal(dc_amt);
		fm.esti_d_etc.value 	= esti_d_etc;
		fm.o_1.value 			= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));
		fm.dc2.value 			= dc2;
		fm.dc_amt2.value 	= parseDecimal(dc_amt2);
		fm.ls_yn.value 		= ls_yn;		
		fm.o_12.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)));
		self.close();
	}	
		
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var codes="";
		var amts=0;	
		var opts="";	
		var jg_opt_sts= "";		
		var jg_tuix_sts= "";	
		var lkas_yn_sts="";	// 차선이탈 제어형 옵션
		var ldws_yn_sts="";	// 차선이탈 경고형 옵션
		var aeb_yn_sts="";	// 긴급제동 제어형 옵션
		var fcw_yn_sts="";	// 긴급제동 경고형 옵션
		var hook_yn_sts="";	// 견인고리
		var o_split;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes   += o_split[0];
					opts    += "["+o_split[1]+"]  ";
					amts    += toInt(o_split[2]);	
					jg_opt_sts = o_split[3];
					jg_tuix_sts = o_split[4];
					lkas_yn_sts = o_split[5];
					ldws_yn_sts = o_split[6];
					aeb_yn_sts = o_split[7];
					fcw_yn_sts = o_split[8];
					hook_yn_sts = o_split[9];
					
					//조정잔가
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_opt_st.value == ''){
								ofm.jg_opt_st.value = jg_opt_sts;	
							}else{
								ofm.jg_opt_st.value = ofm.jg_opt_st.value+'/'+jg_opt_sts;
							}
						}
					}
					//tuix/tuon 옵션여부
					if(jg_tuix_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_tuix_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_tuix_sts) jg_tuix_sts ='';
						}
						if(jg_tuix_sts != ''){
							if(ofm.jg_tuix_opt_st.value == ''){
								ofm.jg_tuix_opt_st.value = jg_tuix_sts;	
							}else{
								ofm.jg_tuix_opt_st.value = ofm.jg_tuix_opt_st.value+'/'+jg_tuix_sts;
							}
						}
					}
					//차선이탈 제어형 옵션여부
					if(lkas_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.lkas_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==lkas_yn_sts) lkas_yn_sts ='';
						}
						if(lkas_yn_sts != ''){
							if(ofm.lkas_yn_opt_st.value == ''){
								ofm.lkas_yn_opt_st.value = lkas_yn_sts;	
							}else{
								ofm.lkas_yn_opt_st.value = ofm.lkas_yn_opt_st.value+'/'+lkas_yn_sts;
							}
						}
					}
					//차선이탈 경고형 옵션여부
					if(ldws_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.ldws_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==ldws_yn_sts) ldws_yn_sts ='';
						}
						if(ldws_yn_sts != ''){
							if(ofm.ldws_yn_opt_st.value == ''){
								ofm.ldws_yn_opt_st.value = ldws_yn_sts;	
							}else{
								ofm.ldws_yn_opt_st.value = ofm.ldws_yn_opt_st.value+'/'+ldws_yn_sts;
							}
						}
					}
					//긴급제동 제어형 옵션여부
					if(aeb_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.aeb_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==aeb_yn_sts) aeb_yn_sts ='';
						}
						if(aeb_yn_sts != ''){
							if(ofm.aeb_yn_opt_st.value == ''){
								ofm.aeb_yn_opt_st.value = aeb_yn_sts;	
							}else{
								ofm.aeb_yn_opt_st.value = ofm.aeb_yn_opt_st.value+'/'+aeb_yn_sts;
							}
						}
					}
					//긴급제동 경고형 옵션여부
					if(fcw_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.fcw_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==fcw_yn_sts) fcw_yn_sts ='';
						}
						if(fcw_yn_sts != ''){
							if(ofm.fcw_yn_opt_st.value == ''){
								ofm.fcw_yn_opt_st.value = fcw_yn_sts;	
							}else{
								ofm.fcw_yn_opt_st.value = ofm.fcw_yn_opt_st.value+'/'+fcw_yn_sts;
							}
						}
					}
					//견인고리 옵션여부
					if(hook_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.hook_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==hook_yn_sts) hook_yn_sts ='';
						}
						if(hook_yn_sts != ''){
							if(ofm.hook_yn_opt_st.value == ''){
								ofm.hook_yn_opt_st.value = hook_yn_sts;	
							}else{
								ofm.hook_yn_opt_st.value = ofm.hook_yn_opt_st.value+'/'+hook_yn_sts;
							}
						}
					}
				}
			}
		}	
		if(cnt == 0){
//		 	alert("선택사양을 선택하세요.");
//			return;
		}
		ofm.opt.value = opts;
		ofm.opt_seq.value = codes;
		ofm.opt_amt.value = parseDecimal(amts);		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)));// + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)));		
		ofm.rg_8_amt.value = parseDecimal(toInt(parseDigit(ofm.o_1.value)) * 25/100);
		self.close();
	}
	
	function DcReg(){	//제조사DC
		var SUBWIN="../car_mst/car_dc_i.jsp?auth_rw=4";	
		window.open(SUBWIN, "CarDcList", "left=200, top=200, width=580, height=400, scrollbars=no, status=yes");
	}	
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<table border=0 cellspacing=0 cellpadding=0 width=550>
    <tr> 
        <td>&nbsp;&nbsp;<%if(idx.equals("1")) {%><img src=../images/center/arrow_cj.gif><%} else if(idx.equals("2")) {%><img src=../images/center/arrow_os.gif><%} else if(idx.equals("3")) {%><img src=../images/center/arrow_ss.gif><%} else if(idx.equals("5")) {%><img src="../images/center/arrow_conti.jpg"/><%} else {%><img src=../images/center/arrow_dc.gif><%}%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<%if(idx.equals("4")){//제조사DC%>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=10%>연번</td>
                    <td class="title" width=40%>D/C구분</td>					
                    <td class="title" width=30%>금액</td>
                    <td class="title" width=20%>기준일자</td>
                </tr>
              <%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
					<td align="center"><%=var.get("CAR_D")%></td>		
                    <td>&nbsp;
					  <a href="javascript:setDcCode('<%=var.get("CAR_B_DT")%>', '<%=var.get("CAR_D")%>', '<%=var.get("CAR_D_SEQ")%>', <%=var.get("CAR_D_PER")%>, <%=var.get("CAR_D_P")%>, '<%=var.get("LS_YN")%>', <%=var.get("CAR_D_PER2")%>, <%=var.get("CAR_D_P2")%>, '<%=var.get("CAR_D_PER_B")%>', '<%=var.get("CAR_D_PER_B2")%>', '<%=var.get("ESTI_D_ETC")%>');">
					    <%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>원
						<%if(String.valueOf(var.get("LS_YN")).equals("Y")){%>
						&nbsp;[리스DC] <%=var.get("CAR_D_PER2")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P2")))%>원
						<%}%>
					  </a>
					</td>					
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT")))%>
					<%if(!String.valueOf(var.get("CAR_D_DT2")).equals("")){%><br>~ <%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT2")))%><%}%>
					</td>
                </tr>
              <%}%>		
            </table>
        </td>
    </tr>	
    <%}else if(idx.equals("5")){ %>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=10%>연번</td>
                    <td class="title" width=30%>엔진</td>					
                    <td class="title" width=30%>복합연비</td>
                    <td class="title" width=30%>비고</td>
                </tr>
              <%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
					<td align="center"><%=var.get("ENGINE")%></td>	
					<td align="center"><a href="javascript:setCode('<%=var.get("CAR_CD")%>','<%=var.get("CAR_K_SEQ")%>','<%=var.get("CAR_K")%>','','','','','','','','','','','','')"><%=var.get("CAR_K")%></a></td>
					<td align="center"><%=var.get("CAR_K_ETC")%></td>
				</tr>
				<%} %>
			</table>
		</td>
	</tr>    	
	<%}else{%>	
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 width=550>
                <tr> 
                    <td class="title" width="30"><%if(idx.equals("2")) {%>선택 <%} else {%>연번 <%}%></td>
                    <td class="title" width="350">종류</td>
                    <td class="title" width="100">가격</td>
                    <td class="title" width="70">기준일자</td>					
                </tr>
                     <%for(int i = 0 ; i < size ; i++){
				    Hashtable var = (Hashtable)vars.elementAt(i);
				    
				    //모델 홈페이지 미사용은 안보여줌
				    if(idx.equals("1") && !String.valueOf(var.get("HP_YN")).equals("Y")) continue;
				    
				    count++;
				    
				    %>		
                <tr> 
                    <td align="center">
                    	<%if(idx.equals("2")){%>
                            <input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>'>
                        <%}else{%>            
                            <%=count%>
                        <%}%>                        
                    </td>
                    <td>&nbsp;<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_2")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("JG_W")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
                    	<%if(idx.equals("1")){%>(<%=var.get("ID")%>-<%=var.get("SEQ")%>)<%}%>
                    	
                    	<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013){%>
		        <%if(!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ){ //옵션,색상%>
		            <br>
		            <%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
		        <%}%>
		        <%}%>
		        
                    </td>
                    <td align="right">&nbsp;<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%> 원&nbsp;&nbsp;</td>						
                    <td align="center"><%=var.get("B_DT")%></td>											
                </tr>
                <%}%>		
             </table>
        </td>
    </tr>
	<%}%>
    <tr>
        <td class=h></td>
    </tr>
  <%if(idx.equals("2")){%>
    <tr> 
        <td align="right"> 
        <a href="javascript:save();"><img src=../images/center/button_conf.gif border=0></a>
        </td>
    </tr>  
  <%}else{%>  
    <tr> 
        <td align="right"> <a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a> </td>
    </tr>  
  <%}%>  
</table>
</form>
</body>
</html>