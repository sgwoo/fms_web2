<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getInsComExtList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
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
<style>
	.comp_amt_pl{
		color:blue;
	}
	.comp_amt_mi{
		color:red;
	}
</style>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_ext_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
<!--   <button type="button" onclick="fnExcelReport('table','title');">Excel Download</button> -->
<table border="0" cellspacing="0" cellpadding="0" width='5800' id="table">
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='450' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title' style='height:51'>연번</td>
		    <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='50' class='title'>점검</td>
		    <td width='100' class='title'>보험사</td>
		    <td width='50' class='title'>상태</td>
        <td width='80' class='title'>등록일</td>
		    <td width="50" class='title'>등록자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='4800'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="27" class='title'>요청</td>
		    <td colspan="18" class='title'>결과</td>
		</tr>
		<tr>
		    <td width='100' class='title'>전보험사</td>
		    <td width='100' class='title'>시작일</td>
		    <td width='50' class='title'>용도</td>
		    <td width='100' class='title'>차량번호</td>
		    <td width='180' class='title'>장기거래처</td>
		    <td width='180' class='title'>상호(보험사용)</td>
		    <td width='80' class='title'>고객구분</td>
		    <td width='200' class='title'>차대번호</td>	
		    <td width='150' class='title'>차명</td>
		    <td width='50' class='title'>차명코드</td>
		    <td width='100' class='title'>차종</td>
		    <td width='100' class='title'>승차정원</td>
		    <td width='100' class='title'>최초등록일</td>
		  <!--   <td width='100' class='title'>에어백</td>
		    <td width='100' class='title'>자동변속기</td>
		    <td width='100' class='title'>ABS장치</td> -->
		    <td width='100' class='title'>연령</td>
		    <td width='100' class='title'>대물</td>
		    <td width='100' class='title'>차기신체사망</td>	
		    <td width='100' class='title'>자기신체부상</td>
		   <!--  <td width='100' class='title'>자차</td>
		    <td width='100' class='title'>무보험</td>
		    <td width='100' class='title'>긴출</td>	 -->
		    <td width='100' class='title'>블랙박스</td>
		    <td width='80 ' class='title'>임직원전용</td>
		    <td width='80 ' class='title'>차선(제어)</td>
		    <td width='80 ' class='title'>차선(경고)</td>
		    
		    <td width='80 ' class='title'>긴급(제어)</td>
		    <td width='80 ' class='title'>긴급(경고)</td>
		    <td width='80 ' class='title'>전기차</td>
		    <td width='80 ' class='title'>견인고리</td>
		    <td width='100 ' class='title'>법률비용지원금</td>
		    
		    <td width='80 ' class='title'>기타장치</td>
		    <td width='100' class='title'>관리담당자</td>
		    <td width='100' class='title'>사업자번호</td>
		    <td width='200' class='title'>대여기간</td>
		    <td width='150' class='title'>블랙박스</td>	
		    
		    <td width='100' class='title'>가격(공급가)</td>
		    <td width='150' class='title'>시리얼번호</td>
		    <%if(gubun1.equals("0007")){%>
		    	<td width='120' class='title'>개발원코드</td>
		    <%}%>
		    <td width='150' class='title'>증권번호</td>
		    <td width='100' class='title'>차량번호</td>
		    <td width='100' class='title'>대인배상</td>
		    
		    <td width='100' class='title'>대인배상</td>
		    <td width='100' class='title'>대물배상</td>
		    <td width='100' class='title'>자기신체사고</td>
		    <td width='100' class='title'>무보험차상해</td>
		    <%if(!gubun1.equals("0007")){%>
		    <td width='100' class='title' class="value38">분담금할증한정</td>
		    <%}%>
		    <td width='100' class='title'>자기차량손해</td>
		    <td width='100' class='title'>긴급출동</td>
		    <td width='100' class='title'>총보험료</td>
		    <td width='100' class='title'>임직원전용보험</td>
		    <td width='300' class='title'>비고</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='450' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>
		    <td width='50' align='center'>
		    	<%if(String.valueOf(ht.get("USE_ST")).equals("등록") || String.valueOf(ht.get("USE_ST")).equals("확인")  || String.valueOf(ht.get("USE_ST")).equals("요청")){%>
		    	<input type="checkbox" name="ch_cd" value="<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>/<%=i%>">
		    	<%}%>
		    </td>
		    <td width='50' align='center'><input type='text' name='chk_cont' size='3' class='whitetext' value=''></td>
		    <td width='100' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 7)%></span></td>
		    <td width='50' align='center'><%=ht.get("USE_ST")%></td>
		    <td width='80' align='center'><%=ht.get("REG_DT2")%></td>
		    <td width='50' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='4800'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	
				String blackbox = "";
				String others="";
				String others_device="";
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					if (String.valueOf(ht.get("VALUE13")).equals("1")) {
						blackbox ="Y";
					} else {
						blackbox ="N";
					}
				
					if (ht.get("VALUE48") == null ) {
						others_device = " ";
					} else {
						others_device = String.valueOf(ht.get("VALUE48"));
					}
					
					int rins_pcp = 0;
					int vins_pcp = 0;
					int vins_gcp = 0;
					int vins_bacdt = 0;
					int vins_canoisr = 0;
					int vins_share = 0;
					int total_amt = 0;
					
					// 첨단안전장치 유무와 전기차 유무에 따른 할인율 적용
					double discountPer = 0;
					
					String val43 = String.valueOf(ht.get("VALUE43")); // 차선(제어)
					String val44 = String.valueOf(ht.get("VALUE44")); // 차선(경고)
					String val45 = String.valueOf(ht.get("VALUE45")); // 긴급(제어)
					String val46 = String.valueOf(ht.get("VALUE46")); // 긴급(경고)
					String val47 = String.valueOf(ht.get("VALUE47")); // 전기차 여부
					
					
					// 첨단안전장치 전체 가입시 최대 6% 적용
					if(val43.equals("Y") && val44.equals("Y") && val45.equals("Y") && val46.equals("Y") && val47.equals("Y")) {
						discountPer = 6;
					// 첨단안전장치 전체 가입이 아닌 경우
					} else {
						// 차선(제어), 차선(경고) 유무에 따른 할인 적용
						if(val43.equals("Y") && val44.equals("Y")) {
							discountPer = discountPer + 4;
						} else if(val43.equals("Y") && val44.equals("N")) {
							discountPer = discountPer + 4;
						} else if(val43.equals("N") && val44.equals("Y")) {
							discountPer = discountPer + 2.5;
						}
						// 긴급제동(제어), 긴급제동(경고) 유무에 따른 할인 적용					
						if(val45.equals("Y") && val46.equals("Y")) {
							discountPer = discountPer + 2;
						} else if(val45.equals("Y") && val46.equals("N")) {
							discountPer = discountPer + 2;
						} else if(val45.equals("N") && val46.equals("Y")) {
							discountPer = discountPer + 1;
						}
						
						// 전기차 할인률 적용 여부
						if(val47.equals("Y")) {
							discountPer = discountPer + 3;
						}
						
						// 총 할인률의 합이 6%가 넘을 경우 최대 6% 적용	
						if(discountPer > 6) {
							discountPer = 6;
						}
					}
					
					// 할인률 적용
					if(discountPer != 0.0 || discountPer != 0 ) {
						discountPer = discountPer * 0.01;
						
					} else {
						discountPer = 0;
					}
					
					if(gubun2.equals("확인") || gubun2.equals("완료")){
						Hashtable cp = ic_db.getCompareAmt(String.valueOf(ht.get("CAR_KD")),String.valueOf(ht.get("INS_COM_NM")),String.valueOf(ht.get("AGE_SCP")),String.valueOf(ht.get("VINS_GCP_KD")),"미가입",String.valueOf(ht.get("COM_EMP_YN")), discountPer);
	
						if(ht.get("VALUE33") != null && cp.get("RINS_PCP_AMT") != null &&
							!String.valueOf(ht.get("VALUE33")).equals("") && !String.valueOf(cp.get("RINS_PCP_AMT")).equals("")	
						){
							rins_pcp = Integer.parseInt(String.valueOf(ht.get("VALUE33")))-Integer.parseInt(String.valueOf(cp.get("RINS_PCP_AMT")));
						}
						
						if(ht.get("VALUE34") != null && cp.get("VINS_PCP_AMT") != null &&
								!String.valueOf(ht.get("VALUE34")).equals("") && !String.valueOf(cp.get("VINS_PCP_AMT")).equals("")	
						){
							vins_pcp = Integer.parseInt(String.valueOf(ht.get("VALUE34")))-Integer.parseInt(String.valueOf(cp.get("VINS_PCP_AMT")));
						}
						
						if(ht.get("VALUE35") != null && cp.get("VINS_GCP_AMT") != null &&
								!String.valueOf(ht.get("VALUE35")).equals("") && !String.valueOf(cp.get("VINS_GCP_AMT")).equals("")	
						){
							vins_gcp = Integer.parseInt(String.valueOf(ht.get("VALUE35")))-Integer.parseInt(String.valueOf(cp.get("VINS_GCP_AMT")));
						}
						
						if(ht.get("VALUE36") != null && cp.get("VINS_BACDT_AMT") != null &&
								!String.valueOf(ht.get("VALUE36")).equals("") && !String.valueOf(cp.get("VINS_BACDT_AMT")).equals("")	
						){
							vins_bacdt = Integer.parseInt(String.valueOf(ht.get("VALUE36")))-Integer.parseInt(String.valueOf(cp.get("VINS_BACDT_AMT")));
						}
						
						if(ht.get("VALUE37") != null && cp.get("VINS_CANOISR_AMT") != null &&
								!String.valueOf(ht.get("VALUE37")).equals("") && !String.valueOf(cp.get("VINS_CANOISR_AMT")).equals("")	
						){
							vins_canoisr = Integer.parseInt(String.valueOf(ht.get("VALUE37")))-Integer.parseInt(String.valueOf(cp.get("VINS_CANOISR_AMT")));
						}
						
						if(ht.get("VALUE38") != null && cp.get("VINS_SHARE_EXTRA_AMT") != null &&
								!String.valueOf(ht.get("VALUE38")).equals("") && !String.valueOf(cp.get("VINS_SHARE_EXTRA_AMT")).equals("")	
						){
							vins_share = Integer.parseInt(String.valueOf(ht.get("VALUE38")))-Integer.parseInt(String.valueOf(cp.get("VINS_SHARE_EXTRA_AMT")));
						}
						if(ht.get("VALUE41") != null && cp.get("TOTAL_AMT") != null &&
								!String.valueOf(ht.get("VALUE41")).equals("") && !String.valueOf(cp.get("TOTAL_AMT")).equals("")	
						){
							total_amt = Integer.parseInt(String.valueOf(ht.get("VALUE41")))-Integer.parseInt(String.valueOf(cp.get("TOTAL_AMT")));
						}
					}
				
				%>			
		<tr>
		        <td width='100' align='center'><%=ht.get("VALUE01")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE03")%></td>
		        <td width='50' align='center'><%=ht.get("VALUE50")%></td>
		        <td width='100' align='center'><a href="javascript:parent.view_ins_com('<%=ht.get("REG_CODE")%>', '<%=ht.get("SEQ")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><%=ht.get("VALUE04")%></a></td>
		        <td width='180' align='center'><span title='<%=ht.get("VALUE23")%>'><%=Util.subData(String.valueOf(ht.get("VALUE23")), 14)%></span></td>
		        <td width='180' align='center'><span title='<%=ht.get("VALUE49")%>'><%=Util.subData(String.valueOf(ht.get("VALUE49")), 14)%></span></td>
		        <td width='80' align='center'><%=ht.get("VALUE51")%></td>
		        <td width='200' align='center'><%=ht.get("VALUE05")%></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE06")%>'><%=Util.subData(String.valueOf(ht.get("VALUE06")), 10)%></span></td>
		        <td width='50' align='center'><%=ht.get("JG_CODE")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE07")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE08")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE09")%></td>
		        <%-- <td width='100' align='center'><%=ht.get("VALUE10")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE11")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE12")%></td> --%>
		        <td width='100' align='center'><%=ht.get("VALUE14")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE15")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE16")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE17")%></td>
		        <%-- <td width='100' align='center'><%=ht.get("VALUE18")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE19")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE20")%></td> --%>
		        <td width='100' align='center'><%=blackbox%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE21")%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE43")%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE44")%></td>
		        
		        <td width='80 ' align='center'><%=ht.get("VALUE45")%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE46")%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE47")%></td>
		        <td width='80 ' align='center'><%=ht.get("VALUE52")%></td>
		        <td width='100 ' align='center'><%=ht.get("VALUE53")%></td>
		        
		        <td width='80 ' align='center'><%=others_device%></td>
		        <td width='100' align='center'><%=ht.get("VALUE24")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE25")%></td>
		        <td width='200' align='center'><%=ht.get("VALUE26")%></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE27")%>'><%=Util.subData(String.valueOf(ht.get("VALUE27")), 10)%></span></td>
		        
		        <td width='100' align='right'><%=ht.get("VALUE28")%></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE29")%>'><%=Util.subData(String.valueOf(ht.get("VALUE29")), 15)%></span></td>
		         <%if(gubun1.equals("0007")){%>
		         	<td width='120' align='center'><%=ht.get("INSUR_CODE")%></td>
		         <%} %>
		        <td width='150' align='center'><%=ht.get("VALUE31")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE32")%></td>
		        
		        <td width='100' align='right'>
			        <%if(rins_pcp>0){%><span class="comp_amt_pl">+<%=rins_pcp%></span> 
			        <%}else if(rins_pcp<0){%><span class="comp_amt_mi"><%=rins_pcp%></span>
		         	<%}%> 		        
			        <%=ht.get("VALUE33")%>
		        </td>
		        
		        <td width='100' align='right'>
       		        <%if(vins_pcp>0){%><span class="comp_amt_pl">+<%=vins_pcp%></span>
			        <%}else if(vins_pcp<0){%><span class="comp_amt_mi"><%=vins_pcp%></span>
			        <%}%>
		        	<%=ht.get("VALUE34")%>
		        </td>
		        
		        <td width='100' align='right'>
    		        <%if(vins_gcp>0){%><span class="comp_amt_pl">+<%=vins_gcp%></span>
		        	<%}else if(vins_gcp<0){%><span class="comp_amt_mi"><%=vins_gcp%></span>
		        	<%}%>
			        <%=ht.get("VALUE35")%>
		        </td>
		        
		        <td width='100' align='right'>
		        	<%if(vins_bacdt>0){%><span class="comp_amt_pl">+<%=vins_bacdt%></span>
		        	<%}else if(vins_bacdt<0){%><span class="comp_amt_mi"><%=vins_bacdt%></span>
		        	<%}%>
		        	<%=ht.get("VALUE36")%>
		        </td>
		        
		        <td width='100' align='right'>
       		        <%if(vins_canoisr>0){%><span class="comp_amt_pl">+<%=vins_canoisr%></span>
		        	<%}else if(vins_canoisr<0){%><span class="comp_amt_mi"><%=vins_canoisr%></span>
			        <%}%>
		    	    <%=ht.get("VALUE37")%>
		        </td>
		        <%if(!gubun1.equals("0007")){%>
		        <td width='100' align='right' class="value38">
			        <%if(vins_share>0){%><span class="comp_amt_pl">+<%=vins_share%></span>
		        	<%}else if(vins_share<0){%><span class="comp_amt_mi"><%=vins_share%></span>
		        	<%}%>	        
			        <%=ht.get("VALUE38")%>
		        </td>
		        <%}%>
		        
		        <td width='100' align='right'><%=ht.get("VALUE39")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE40")%></td>
		        
		        <td width='100' align='right'>
    		        <%if(total_amt>0){%><span class="comp_amt_pl">+<%=total_amt%></span>
		         	<%}else if(total_amt<0){%><span class="comp_amt_mi"><%=total_amt%></span>
		         	<%}%>
		        	<%=ht.get("VALUE41")%>
		        </td>
		        
		        <td width='100' align='center'><%=ht.get("VALUE42")%></td>
		        <td width='300'>&nbsp;<%=ht.get("ETC")%></td>
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='450' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='4800'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->


	function fnExcelReport(id, title) {
		var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
		tab_text = tab_text
				+ '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
		tab_text = tab_text
				+ '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
		tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
		tab_text = tab_text
				+ '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
		tab_text = tab_text
				+ '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
		tab_text = tab_text + "<table border='1px'>";
		var exportTable = $('#' + id).clone();
		exportTable.find('input').each(function(index, elem) {
			$(elem).remove();
		});
		tab_text = tab_text + exportTable.html();
		tab_text = tab_text + '</table></body></html>';
		var data_type = 'data:application/vnd.ms-excel';
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE ");
		var fileName = title + '.xls';
		//Explorer 환경에서 다운로드
		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
			if (window.navigator.msSaveBlob) {
				var blob = new Blob([ tab_text ], {
					type : "application/csv;charset=utf-8;"
				});
				navigator.msSaveBlob(blob, fileName);
			}
		} else {
			var blob2 = new Blob([ tab_text ], {
				type : "application/csv;charset=utf-8;"
			});
			var filename = fileName;
			var elem = window.document.createElement('a');
			elem.href = window.URL.createObjectURL(blob2);
			elem.download = filename;
			document.body.appendChild(elem);
			elem.click();
			document.body.removeChild(elem);
		}
	}
</script>
</body>
</html>

