<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*, acar.fee.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String rent="";
	int count= 0;
	int  cnt[]   = new int[16];
  	long amt[]   = new long[16];
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector settles = s_db.getSettleList_20091001(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd);
	int settle_size = settles.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	String var3 = e_db.getEstiSikVarCase("1", "", "dly1_bus3");
	String var6 = e_db.getEstiSikVarCase("1", "", "dly1_bus6");
	
	Hashtable my_stat = s_db.getSettleMyInsAmtStat(s_kd, t_wd, var3, var6);
	Hashtable gu_stat = s_db.getSettleClsGuaInsAmtStat(s_kd, t_wd, var3, var6);
	
	String master_mode = "";
	if(nm_db.getWorkAuthUser("채권관리팀",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		master_mode = "Y";
	}
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='fee_size' value='<%=settle_size%>'>
<input type='hidden' name='var3' value='<%=var3%>'>
<input type='hidden' name='var6' value='<%=var6%>'>
<input type='hidden' name='o_client_id' value=''>
<input type='hidden' name='chk_yn'  id='chk_yn' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='1980'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='550' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' rowspan='2' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				
                    <td colspan="5" class='title'>기본 정보</td>
                </tr>
                <tr> 
                    <td width='100' class='title'>연번</td>
                    <td width='80' class='title'>납부약속일</td>
                    <td width="100" class='title'>계약번호</td>
                    <td width='160' class='title'>상호</td>
                    <td width="80" class='title'>차량번호</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1430'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' colspan="2">선수금</td>
                    <td class='title' colspan="2">대여료</td>
                    <td class='title' >연체이자</td>					
                    <td class='title' colspan="2">과태료</td>
                    <td class='title' colspan="2">면책금</td>
                    <td class='title' colspan="2">휴/대차료</td>
                    <td class='title' colspan="2">해지정산금</td>
                    <td class='title' colspan="2">단기요금</td>			
                    <td class='title' colspan="2">합계</td>			
                    <td class='title' width="70" rowspan="2">영업담당자</td>
                    <td class='title' width="70" rowspan="2">예비담당자</td>
                    <td class='title' width="50" rowspan="2">정산서</td>
					<td class='title' width="140" rowspan="2">채권</td>
                </tr>
                <tr> 
                    <td width='40' class='title'>건수</td>
                    <td width='80' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='80' class='title'>금액</td>
                    <!--<td width='40' class='title'>건수</td>-->
                    <td width='80' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='80' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='70' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='70' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='80' class='title'>금액</td>
                    <td width='40' class='title'>건수</td>
                    <td width='70' class='title'>금액</td>			
                    <td width='40' class='title'>건수</td>
                    <td width='90' class='title'>금액</td>			
                </tr>
            </table>
	    </td>
    </tr>
<%	if(settle_size > 0){%>
    <tr>
	    <td class='line' width='550' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);
						
						String cng_yn = "N";
						String bad_yn = "N";
						long bad_amt  = 0;
						if(settle.get("USE_YN").equals("N")){
							//채권추심의뢰요청 가능여부
							if(AddUtil.parseInt(String.valueOf(settle.get("CLS_USE_MON")))>1 && AddUtil.parseLong(String.valueOf(settle.get("EST_AMT7")))+AddUtil.parseLong(String.valueOf(settle.get("EST_AMT2")))>0){
								cng_yn = "Y";
							}
							//소액채권대손처리요청 가능여부
							bad_amt = AddUtil.parseLong(String.valueOf(settle.get("EST_AMT7")))+AddUtil.parseLong(String.valueOf(settle.get("EST_AMT4")))+AddUtil.parseLong(String.valueOf(settle.get("EST_AMT5")));
							if(AddUtil.parseInt(String.valueOf(settle.get("CLS_USE_MON")))>1 && bad_amt <=300000){
								bad_yn = "Y";
							}
						}
				%>
                <tr> 
                  <td width='30' align='center'>
		            <input type="checkbox" name="ch_cd"  value="<%=settle.get("RENT_MNG_ID")%><%=settle.get("RENT_L_CD")%><%=i%>">
					<input type='hidden' name='client_id' value='<%=settle.get("CLIENT_ID")%>'>
					<input type='hidden' name='cng_yn' value='<%=cng_yn%>'>
					<input type='hidden' name='bad_yn' value='<%=bad_yn%>'>
					<input type='hidden' name='bad_amt' value='<%=bad_amt%>'>
					<input type='hidden' name='bad_cls_amt' value='<%=settle.get("EST_AMT7")%>'>
					<input type='hidden' name='bad_fine_amt' value='<%=settle.get("EST_AMT4")%>'>
					<input type='hidden' name='bad_serv_amt' value='<%=settle.get("EST_AMT5")%>'>
					<input type='hidden' name='cls_use_mon' value='<%=settle.get("CLS_USE_MON")%>'>
					<input type='hidden' name='bad_fee_su' value='<%=settle.get("EST_SU2")%>'>
					<input type='hidden' name='fee_dly_mon' value='<%=settle.get("DLY_MON")%>'>
					<input type='hidden' name='use_yn<%=i%>' id='use_yn<%=i%>' value='<%=settle.get("USE_YN")%>'>
		          </td>						  
                  <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><a href="javascript:parent.view_memo('<%=settle.get("RENT_MNG_ID")%>','<%=settle.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"  title="<%=af_db.getMaxMemo("", String.valueOf(settle.get("RENT_L_CD")), "")%>"><%=i+1%></a>
                  
              		<%if(settle.get("USE_YN").equals("N")){%>
			  		<%	if(cng_yn.equals("Y")){%>
              		<span title='해지일로부터 <%=settle.get("CLS_USE_MON")%>개월 경과, 채권추심의뢰 가능합니다.'>(추심가능)</span>
			  		<%	}else{%>
			  		<span title='해지일로부터 <%=settle.get("CLS_USE_MON")%>개월 경과되었음.'>(해약)</span>
			  		<%	}%>
              		<%}else{%>
			  		<%	if(!settle.get("IN_CNT").equals("0")){%>
              		(회수) 
              		<%	}%>
			  		<%}%>
                    </td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width="80" align='center'><%=AddUtil.ChangeDate2(String.valueOf(settle.get("PROMISE_DT")))%></td>        
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width="100" align='center' ><a href="javascript:parent.view_settle('cont','','<%=settle.get("RENT_L_CD")%>','<%=settle.get("CLIENT_ID")%>','<%=settle.get("CAR_MNG_ID")%>','<%=settle.get("GUBUN3")%>')" onMouseOver="window.status=''; return true"><%=settle.get("RENT_L_CD")%></a></td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='160' align='center'><%if(settle.get("CAR_ST").equals("4")){%><span style="color:red;">(월)</span><%}%><span title='<%=settle.get("GUBUN3")%> <%=settle.get("FIRM_NM")%>'><a href="javascript:parent.view_settle('client','','<%=settle.get("RENT_L_CD")%>','<%=settle.get("CLIENT_ID")%>','<%=settle.get("CAR_MNG_ID")%>','<%=settle.get("GUBUN3")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(settle.get("GUBUN3"))+""+String.valueOf(settle.get("FIRM_NM")), 10)%></a></span></td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width="80" align='center'><%=settle.get("CAR_NO")%></td>
                </tr>
          <%		}%>
            </table>
	    </td>
	    <td class='line' width='1430'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);
						
						for(int j=0; j<9; j++){
							cnt[j]  += AddUtil.parseInt(String.valueOf(settle.get("EST_SU"+j)));
							amt[j]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT"+j)));
						}
						
						if(!settle.get("EST_SU10").equals("0")){ //승계수수료 
							cnt[15]  += AddUtil.parseInt(String.valueOf(settle.get("EST_SU10")));
							amt[15]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT10")));
						}
						
						
						if(!settle.get("IN_CNT").equals("0")){ //회수차량
							cnt[9]  += AddUtil.parseInt(String.valueOf(settle.get("EST_SU2")));
							amt[9]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT2")));
						}
						//단기요금(월렌트) 실반영금액
						if(!settle.get("EST_AMT8_2").equals("0")){							
							amt[11]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT8_2")));
							
							//캠페인마감당일에는 제외한다.
							if(var3.equals(AddUtil.getDate(4))){
								amt[11] = 0;	
							}							
						}
						//월렌트 실반영금액
						if(!settle.get("EST_AMT2_2").equals("0")){							
							amt[12]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT2_2")));																					
						}
						//월렌트정산금 실반영금액
						if(!settle.get("EST_AMT7_2").equals("0")){							
							amt[13]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT7_2")));																					
						}

						//기간경과 미청구분 실반영액
						if(!settle.get("EST_AMT2_3").equals("0")){							
							amt[14]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT2_3")));																					
						}
						
						
						
						
						long r_cls_amt = AddUtil.parseLong(String.valueOf(settle.get("EST_AMT7")))-AddUtil.parseLong(String.valueOf(settle.get("EST_AMT9")));
						
						if(r_cls_amt < 0){
							r_cls_amt = 0;
						}
						
						if(amt[7]>0 && r_cls_amt>0){
							if(r_cls_amt>1000000){
								r_cls_amt = 1000000+((r_cls_amt-1000000)*20/100);
							}
							amt[10]  += r_cls_amt;
						}
						
						String bad_yn = "N";
						long bad_amt  = 0;
						if(settle.get("USE_YN").equals("N")){
							bad_amt = AddUtil.parseLong(String.valueOf(settle.get("EST_AMT0")));
							if(AddUtil.parseInt(String.valueOf(settle.get("CLS_USE_MON")))>1 && bad_amt >0){	//bad_amt <=330000 && 
								bad_yn = "Y";
							}
						}
						
						//if(!String.valueOf(settle.get("RENT_S_CD")).equals("") && AddUtil.parseLong(String.valueOf(settle.get("EST_AMT8")))==0){	
						//	settle.put("RENT_S_CD", "");
						//}
						%>
                <tr> 
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU1")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT1")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU2")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT2")))%>원</td>
                    <!--<td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU3")%>건</td>-->
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT3")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU4")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT4")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU5")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT5")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU6")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT6")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU7")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT7")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU8")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT8")))%>원</td>					
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU0")%>건</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT0")))%>원</td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="70"><%=c_db.getNameById(String.valueOf(settle.get("BUS_ID2")),"USER")%></td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="70"><%=c_db.getNameById(String.valueOf(settle.get("MNG_ID2")),"USER")%></td>
                    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="50">
                   	<%if(!settle.get("USE_YN").equals("N")){//해약건이면 보기버튼 안보이게(20190731)%>
                    	<a href="javascript:parent.view_settle_doc('<%=settle.get("RENT_MNG_ID")%>','<%=settle.get("RENT_L_CD")%>', '<%=settle.get("USE_YN")%>')"><img src=../images/center/button_in_see.gif align=absmiddle border=0></a>
                    <%} %>
                    </td>
		    <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="140">
			  <%if(bad_yn.equals("Y") || master_mode.equals("Y")){%>
			  	  <%if(!String.valueOf(settle.get("EST_AMT6")).equals(String.valueOf(settle.get("EST_AMT0")))){ //휴,대차료건만 있을시 대손요청불가(20190731)%>		
				      <a href="javascript:parent.settle_acc_bad_debt_req('<%=settle.get("BAD_DEBT_REQ")%>','<%=settle.get("RENT_MNG_ID")%>','<%=settle.get("RENT_L_CD")%>', '<%=settle.get("CLS_USE_MON")%>','<%=bad_amt%>','<%=settle.get("CAR_MNG_ID")%>','<%=settle.get("RENT_S_CD")%>')" title='채권 대손처리 요청하기'>
				          [대손요청]
				      </a>
				  <%}%>    
			  <%}%>			  
			  <%if(String.valueOf(settle.get("CAR_ST")).equals("4") || String.valueOf(settle.get("RENT_L_CD")).equals("S112HHLR00070") || String.valueOf(settle.get("RENT_L_CD")).equals("S113HXAL00021") || String.valueOf(settle.get("RENT_L_CD")).equals("S113HXAL00021") || String.valueOf(settle.get("RENT_L_CD")).equals("B110SS7R00030") || String.valueOf(settle.get("RENT_L_CD")).equals("D112KMOL00020") || (String.valueOf(settle.get("USE_YN")).equals("Y") && AddUtil.parseInt(String.valueOf(settle.get("DLY_MON"))) >= 1)){%>	
			      <a href="javascript:parent.settle_acc_bad_complaint_req('<%=settle.get("CLIENT_ID")%>')" title='고소장접수 요청하기'>
			          [고소장]
			      </a>
			  <%}%>			  
		    </td>
                </tr>
          <%		}%>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='550' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td align='center'>등록된 데이타가 없습니다</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line' width='1430'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	<%for(int j=0; j<9; j++){%>
	parent.document.form1.cnt[<%=j%>].value = '<%=cnt[j]%>';
	parent.document.form1.amt[<%=j%>].value = '<%=Util.parseDecimal(amt[j])%>';
	<%}%>
	parent.document.form1.in_cnt.value = '<%=cnt[9]%>';
	parent.document.form1.in_amt.value = '<%=Util.parseDecimal(amt[9])%>';
	
	parent.document.form1.e_cnt.value = '<%=cnt[15]%>';
	parent.document.form1.e_amt.value = '<%=Util.parseDecimal(amt[15]*3)%>'; <!--승계수수료 -->
	
	var var3 = '<%=var3%>';
	var var6 = '<%=var6%>';
	var h_amt  = 0;
	var g_amt  = 0;
	var t_amt0 = 0;
	var t_amt1 = 0;
	var t_amt2 = 0;
	var t_amt3 = 0;
	var t_amt4 = 0;
	var t_amt5 = 0;
	var t_amt6 = 0;
	var t_amt7 = 0;
	var t_amt8 = 0;	

	<%if(!String.valueOf(my_stat.get("AMT")).equals("")){%>
	h_amt  = <%=my_stat.get("AMT")==null?"0":my_stat.get("AMT")%>;
	<%}%>
	<%if(!String.valueOf(gu_stat.get("AMT")).equals("")){%>	
	g_amt  = <%=gu_stat.get("AMT")==null?"0":gu_stat.get("AMT")%>;
	<%}%>	
	

	t_amt1 = <%=amt[1]%>-<%=amt[15]%>+(<%=amt[15]%>*3); //선수금- 승계수수료*3적용
	t_amt2 = <%=amt[2]%>-<%=amt[9]%>+(<%=amt[9]%>*0.1);
	t_amt3 = <%=amt[3]%>;
//	t_amt4 = <%=amt[4]%>*5;
	t_amt4 = <%=amt[4]%>*1; //20131022 201310 워크샵에서 1배수로 변경
//	t_amt5 = <%=amt[5]%>*5; //20120126 2012년1분기부터 5배수에서 1배수로 변경
	t_amt5 = <%=amt[5]%>*1;
	t_amt6 = h_amt;
//	t_amt7 = (<%=amt[7]%>-g_amt)*0.1;
	t_amt7 = <%=amt[10]%>;
	t_amt8 = <%=amt[8]%>; //단기
	
	//캠페인마감당일에는 제외한다.
  	<%if(var3.equals(AddUtil.getDate(4))){%>
  	t_amt2 = t_amt2-<%=amt[12]%>;//월렌트대여료
  	t_amt7 = t_amt7-<%=amt[13]%>;//월렌트정산금
  	<%}%>
  	
  	//20140729 기간경과 미청구분 실반영(3일경과부터)
  	t_amt2 = t_amt2-<%=amt[14]%>;//월렌트대여료
							
	
	parent.document.form1.h_cnt.value = '<%=my_stat.get("CNT")==null?"0":my_stat.get("CNT")%>';
	parent.document.form1.h_amt.value = parseDecimal(h_amt);
	
	parent.document.form1.g_cnt.value = '<%=gu_stat.get("CNT")==null?"0":gu_stat.get("CNT")%>';
	parent.document.form1.g_amt.value = parseDecimal(g_amt);

	/*반영*/
	parent.document.form1.cnt[10].value  = '<%=cnt[1]%>';
	parent.document.form1.amt[10].value  = parseDecimal(t_amt1);
	
	parent.document.form1.cnt[11].value = '<%=cnt[2]%>';
	parent.document.form1.amt[11].value = parseDecimal(t_amt2);

	parent.document.form1.cnt[12].value = '<%=cnt[3]%>';
	parent.document.form1.amt[12].value = parseDecimal(t_amt3);

	parent.document.form1.cnt[13].value = '<%=cnt[4]%>';
	parent.document.form1.amt[13].value = parseDecimal(t_amt4);

	parent.document.form1.cnt[14].value = '<%=cnt[5]%>';
	parent.document.form1.amt[14].value = parseDecimal(t_amt5);

	parent.document.form1.cnt[15].value = '<%=cnt[6]%>';
	parent.document.form1.amt[15].value = parseDecimal(t_amt6);
	
	parent.document.form1.cnt[16].value = '<%=cnt[7]%>';
	parent.document.form1.amt[16].value = parseDecimal(t_amt7);

	parent.document.form1.cnt[17].value = '<%=cnt[8]%>';
	parent.document.form1.amt[17].value = parseDecimal(<%=amt[11]%>);
	
	parent.document.form1.cnt[9].value = '<%=cnt[0]%>';
	parent.document.form1.amt[9].value = parseDecimal(t_amt1+t_amt2+t_amt3+t_amt4+t_amt5+t_amt6+t_amt7+<%=amt[11]%>);
	
	
//-->
</script>
</form>
</body>
</html>
