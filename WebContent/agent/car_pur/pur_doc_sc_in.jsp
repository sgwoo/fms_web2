<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	// 브라우저가 크롬일 경우 판별		2018.01.12
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = d_db.getCarPurDocListA(s_kd, t_wd, gubun1, gubun3, gubun4, st_dt, end_dt, ck_acar_id);
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
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/car_pur/pur_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    

    <table border="0" cellspacing="0" cellpadding="0" width='1860'>
        <tr>
            <td colspan="2" class=line2></td>
        </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='460' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td width='40' class='title' style='height:51'>연번</td>
			<!-- <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td> -->				  					
			<td width='60' class='title'>구분</td>
		        <td width='100' class='title'>계약번호</td>
        		<td width='80' class='title'>계약일</td>
		        <td width="100" class='title'>고객</td>
		        <td width="50" class='title'>최초<br>영업</td>					
		    </tr>
		</table>
	    </td>
	    <td class='line' width='1400'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
		    <td width='100' rowspan="2" class='title'>차명</td>
		    <%if(!gubun1.equals("0")) { %>
			<td colspan="3" class='title'>결재</td>
			<%}else{ %>
			<td colspan="1" class='title'>결재</td>
			<%} %>		
			<%if(!gubun1.equals("0")) { %>	
			<td rowspan='2' width='80' class='title'>지급요청일</td>
			<%} %>				
			<%if(!gubun1.equals("2")) { %>					
			<td colspan="4" class='title'>조건</td>
			<%} %>
			<td colspan="3" class='title'>탁송</td>
			<td colspan="5" class='title'>출고지점</td>
		    </tr>
		    <tr>		    
			<td width='60' class='title'>기안자</td>
			<%if(!gubun1.equals("0")) { %>
			<td width='60' class='title'>출고관리</td>
			<td width='60' class='title'>팀장</td>
			<%} %>
			<%if(!gubun1.equals("2")) { %>		
			<td width='30' class='title'>불충</td>				  		  				  
			<td width='30' class='title'>스캔</td>							  
			<td width='70' class='title'>보증보험</td>
			<td width='80'  class='title'>초기선납금</td>
			<%} %>
			<td width='80' class='title'>구분</td>
			<td width='80' class='title'>출고지</td>
			<td width='80' class='title'>인수지</td>
			<td width='100' class='title'>제조사</td>
			<td width='70' class='title'>구분</td>				  				  
			<td width='150' class='title'>영업소</td>
			<td width='70' class='title'>영업사원</td>
			<td width='80' class='title'>계약금</td>				  
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
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		    <tr>
		        <td  width='40' align='center'><%=i+1%></td>
		        <!-- 
		        <td  width='30' align='center'><%if(!String.valueOf(ht.get("DOC_STEP")).equals("") && String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_EST_AMT")%>" onclick="javascript:parent.select_purs_amt();"><%}else{%>-<%}%></td>
		         -->
		        <td  width='60' align='center'>
		            <%if(String.valueOf(ht.get("DLV_DT")).equals("") && String.valueOf(ht.get("DOC_STEP")).equals("1")){%>
			        <a href="javascript:parent.doc_cancel('<%=ht.get("DOC_NO")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif"  align="absmiddle" border="0"></a>
			    <%}else{%>
			        <span title='<%=ht.get("DELAY_CONT")%>'>
			        <%	if(String.valueOf(ht.get("BIT")).equals("대기") && AddUtil.parseInt(String.valueOf(ht.get("DELAY_MON"))) > 0){%>
			        <a href="javascript:parent.reg_delay_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">장기</a>
			        <%	}%>
			        <%=ht.get("BIT")%>
			        </span>
			     <%}%>
		        </td>
		        <td  width='100' align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
		        <td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>		        
		        <td  width='100'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 5)%></span></td>
		        <td  width='50' align='center'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>					
		    </tr>
<%
		}
%>
		</table>
	    </td>
	    <td class='line' width='1400'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String scan_cnt			= String.valueOf(ht.get("SCAN_CNT"));
			String dlv_dt	 		= String.valueOf(ht.get("DLV_DT"));
			String gi_st 			= String.valueOf(ht.get("GI_ST2"));
			String pp_st 			= String.valueOf(ht.get("PP_ST"));
			String scd_yn 			= String.valueOf(ht.get("SCD_YN"));
			String file_name1		= String.valueOf(ht.get("FILE_NAME1"));
			String file_name2		= String.valueOf(ht.get("FILE_NAME2"));
			String req_dt			= String.valueOf(ht.get("REQ_DT"));
			String sup_dt			= String.valueOf(ht.get("SUP_DT"));
			int chk_cnt = 0;
			if(String.valueOf(ht.get("USE_ST")).equals("미결"))		chk_cnt++; //에이전트는 계약결재완료가 기준조건이다.
%>			
		    <tr>
			<td  width='100'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>				
			<td  width='60' align='center'>
			  <!--기안자-->
			  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
			  	<%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
			  		<img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0">
			  	<%}else{%>
			  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%>
			  	<%}%>
				</a>	
			  </td>
			<%if(!gubun1.equals("0")) { %>  			
			<td  width='60' align='center'>
			  <!--출고담당자-->
			  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%><%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>-<%}else{%><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%><%}%><%}%>
			  </td>			
			<td  width='60' align='center'>
			  <!--총무팀장-->
			  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%><%if(String.valueOf(ht.get("USER_DT5")).equals("")){%>-<%}else{%><%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER")%><%}%><%}%>
			  </td>
			  <%}%>
			  <%if(!gubun1.equals("0")) { %>
			<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_EST_DT")))%></td>
			<%}%>
			<%if(!gubun1.equals("2")) { %>		
			<td  width='30' align='center'><%=chk_cnt%></td>										
			<td  width='30' align='center'><a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%if(scan_cnt.equals("0")){%><font color=red><%}%><%=scan_cnt%><%if(gi_st.equals("0")){%></font><%}%></a><span title='매매주문서 스캔 확인'><%=ht.get("SCAN_15_CNT")%></span></td>			
			<td  width='70' align='center'><%if(gi_st.equals("미가입")){%><font color=red><%}%><%=gi_st%><%if(gi_st.equals("미가입")){%></font><%}%></td>
			<td  width='80' align='center'><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%><font color=red><%}%><span title='<%if(pp_st.equals("입금완료")){%>입금완료<%}else{%><%=Util.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>원<%}%>'><%if(pp_st.equals("입금완료")){%><%=ht.get("PP_PAY_DT")%><%}else{%><%=pp_st%><%}%></span><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%></font><%}%><%=ht.get("CONT_RENT_ST_NM")%></td>
			<%} %>
			<td  width='80' align='center'>
			    <!--현대자동차 자체탁송 의뢰--> 
			    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("현대자동차(주)")){%>
			    
			    <%	if(!String.valueOf(ht.get("CAR_OFF_NM")).equals("B2B사업운영팀") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("법인판매팀") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("법인판촉팀") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("특판팀")){%>
			        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
			        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
			    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
			            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
			    <%			}%>    
			        </a>
			    
			    <%	}else{%>
			    <%		if(String.valueOf(ht.get("USER_DT1")).equals("")){%>			        
			    <%		}else{%>
			        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
			        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
			    <%			if(String.valueOf(ht.get("CONS_ST")).equals("2") && String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
			            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
			    <%			}%>    
			        </a>
			    <%		}%>
			    <%	}%>
			    
			    <%}%>
			    
			    <!--기아자동차 자체탁송 의뢰--> 
			    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("기아자동차(주)")){%>			    
                                <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
			        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
			    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
			            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
			    <%			}%>    
			        </a>			    			    
			    <%}%>			    
			</td>
			<td  width='80' align='center'><span title='<%=ht.get("DLV_EXT")%>'><%=Util.subData(String.valueOf(ht.get("DLV_EXT")), 6)%></span></td>
			<td  width='80' align='center'><%=ht.get("UDT_ST")%></td>
			<td  width='100' align='center'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_COMP_NM")), 8)%></span></td>
			<td  width='70' align='center'><%=ht.get("ONE_SELF")%></td>
			<td  width='150' align='center'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_OFF_NM")), 10)%></span></td>
			<td  width='70' align='center'><a href="javascript:parent.view_emp('<%=ht.get("EMP_ID")%>')";><span title='<%=ht.get("EMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></span></a></td>
			<td  width='80' align='center'><span title='출고 계약금'><%=ht.get("CON_AMT")%></span><!-- <a href="javascript:parent.view_con_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')";>문서</a> --></td>					
		    </tr>
<%
		}
%>
		</table>
	    </td>
	</tr>    
<%	}                  
	else               
	{
%>                     
	<tr>
	    <td class='line' width='460' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td align='center'>
			    <%if(t_wd.equals("")){%>검색어를 입력하십시오.
			    <%}else{%>등록된 데이타가 없습니다<%}%>
			</td>
		    </tr>
		</table>
	    </td>
	    <td class='line' width='1400'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
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
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
