<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.accid.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	LoginBean login = LoginBean.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	if  ( !user_nm.equals("전체") ) {
		Hashtable id = c_db.getDamdang_id(user_nm);
		user_id = String.valueOf(id.get("USER_ID"));
	} else {
	          user_id = "";
	}
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");	
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	
	Vector cmls = cp_db.getCar_maintList(user_id, s_kd, t_wd);
				

	//영업용차량 차령만료예정
	Vector vt3 = ad_db.getCarEndDtEstList(user_id);
	int vt_size3 = vt3.size();
	
	
	//한국교통안전공단기준  만기도래 5일전 (fms에 입력이 안되어있으면 리스트 보여짐)
    Vector vt4 = ad_db.getCarCybertsList();
	int vt_size4 = vt4.size();
	
	String regdt="";
	
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//검색하기	
function adjust_vst(client_id,seq){
	var SUBWIN="../cus_reg/vst_reg.jsp?client_id=" + client_id + "&seq=" + seq + "&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	window.open(SUBWIN, 'popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50');
}
function go_cus_reg_visit(firm_nm){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=1&t_wd="+firm_nm;
	fm.target = "d_content";
	fm.submit();
}
function go_cus_reg_serv(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=2&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}

function go_cus_reg_maint(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=3&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}

function serv_apply(rmid,rlcd,irid){
	var fm = document.form1;
	if(!confirm('해당 예약건을 완료 하시겠습니까?')){ return; }	
	fm.target = "i_no";
	fm.action = "../cus0404/serv_apply_ok.jsp?rent_mng_id="+rmid+"&rent_l_cd="+rlcd+"&ires_id="+irid+"&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	fm.submit();
}
	//고객 보기
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
		function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st, idx){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.idx.value = idx;						
		fm.cmd.value = "u";	

		var url = "?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&accid_st="+accid_st+"&idx="+idx;
		var SUBWIN = "/acar/accid_mng/accid_u_frame.jsp" + url;
	//	window.open(SUBWIN, 'AccidentDisp','scrollbars=yes,status=no,resizable=no,width=900,height=700,top=50,left=50');

		fm.action='/acar/accid_mng/accid_u_frame.jsp';
		fm.target = "d_content";
		fm.submit();
	}
	
function next_serv_cng(car_mng_id, serv_id){
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;	
	var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

	var SUBWIN="/acar/cus_sch/next_serv_cng.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_next_serv_cng','scrollbars=yes,status=no,resizable=no,width=440,height=150,top=200,left=500');
}

//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function multireg() {
	var fm=document.form1;
	
	fm.action='/acar/cus_pre/car_req_master2.jsp';
	fm.target='_blank';
	fm.submit();
}

function dg_input(number)
{
	var SUBWIN="http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+number; //우체국등기조회링크
	window.open(SUBWIN, "dg_input", "left=50, top=50, width=850, height=300, resizable=yes, scrollbars=yes");
}		

function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
function view_email(m_id, l_cd, c_id){
		window.open("http://fms1.amazoncar.co.kr/mailing/ser/insp.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id, "VIEW_EMAIL", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	
function view_sms(m_id, l_cd, c_id, car_no){
		window.open("/acar/cus_pre/cus_pre_sms.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&car_no="+car_no+"&auth_rw=<%=auth_rw%>", "VIEW_EMAIL", "left=100, top=100, width=800, height=550, scrollbars=yes");
	}	
	function serv_action(car_mng_id, serv_id, accid_id){
		var fm = document.form1;
		var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id+"&from_page=/acar/cus_pre/cus_pre_sc_gs.jsp"; 
		window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=720,top=50,left=50');
	}
	
	
	function cus_pre_c(car_mng_id, car_no, m_id , l_cd){

	var SUBWIN="/acar/cus_pre/cus_pre_c.jsp?c_id=" + car_mng_id+"&car_no="+car_no+"&m_id="+m_id+"&l_cd="+l_cd;	
	
	window.open(SUBWIN, 'AncDisp','scrollbars=yes,status=no,resizable=no,width=680,height=450,top=200,left=300');
}
	
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='0'></a></td>
    </tr>
     <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>한국교통안전공단 검사도래 7일전 차량  : 총 <font color="#FF0000"><%= vt_size4 %></font>건</span>
        &nbsp;&nbsp;<a href="javascript:var win=window.open('cyberts_reg.jsp','popup','left=10, top=10, width=900, height=600, status=no, scrollbars=yes, resizable=no');"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>
       &nbsp;&nbsp;<span>[<b>Excel통합문서</b> 또는 <b>Excel97-2003 통합문서</b>] 만 가능하오니 다른이름으로 저장 후 등록하셔야 합니다</span> 
        </td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;* 해당 리스트의 차량은 검사를 진행하였어도 다음 엑셀등록시까지 변경되지 않으니 업무에 참고하세요!!!.          
        </td>
    </tr>
   <tr>
        <td>&nbsp;&nbsp;&nbsp;<b>* 엑셀등록일:&nbsp;  
     <%if(vt_size4 > 0){          
				for (int i = 0 ; i < 1 ; i++){
				          	   
						Hashtable ht1 = (Hashtable)vt4.elementAt(i);
						
						regdt= String.valueOf(ht1.get("REG_DT"));
				%>    
   <% } }%>
        <%=regdt %> </b>         
        </td>
    </tr>
   
					
    
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='14%' class='title'>상호</td>                  
                    <td width='8%' class='title'>차량번호</td>
                    <td width='9%' class='title'>차대번호</td> 
                    <td width='13%' class='title'>차명</td>
                    <td width='7%' class='title'>유효기간<br>만료일</td>
                    <td width='7%' class='title'>차령기간<br>만료일</td>
                    <td width='4%' class='title'>연식</td>
                    <td width='6%' class='title'>배출가스 등급</td>
                    <td width='7%' class='title'>최초등록일</td>
                    <td width='7%' class='title'>계약만료일</td>   
                    <td width='7%' class='title'>관리담당</td>
                    <td width='8%' class='title'>관리번호</td>
                </tr>
                        
          <%if(vt_size4 > 0){
          
				for (int i = 0 ; i < vt_size4 ; i++){
				          	   
						Hashtable ht = (Hashtable)vt4.elementAt(i);
					%>
                <tr>
                    <td align="center"><%=i+1%></td>            
                    <td align="center"><%if(String.valueOf(ht.get("RRM")).equals("0")){%><b>(월)</b><%} %>&nbsp;<%=ht.get("FIRM_NM") %></td>
                    <td align="center"><%= ht.get("CAR_NO") %></td>
                    <td align="center"><%= ht.get("CAR_NUM") %></td>            
                    <td align="center"><%= ht.get("CAR_NAME") %></td>
                    <td align="center"><%= ht.get("END_DT") %></td>
                    <td align="center"><%= ht.get("CAR_END_DT") %></td>
                    <td align="center"><%= ht.get("CAR_YY") %></td>
                    <td align="center"><%= ht.get("CAR_TYPE") %></td>    
 					<td align="center"><%= ht.get("INIT_REG_DT") %></td>
 					<td align="center"><%= AddUtil.ChangeDate2((String)ht.get("RENT_END_DT")) %></td>
 					<td align="center"><%= c_db.getNameById((String)ht.get("BUS_ID2"),"USER") %></td>
 					<td align="center"><%= ht.get("CAR_DOC_NO") %></td>
                 
		        </tr>
          <%  }
			}else{%>  
                <tr>
                    <td colspan="14" align="center">자료가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	  
     <tr> 
        <td><a name='1'></a></td>
    </tr>	
            
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업용 차량 <b>차령만료</b>예정 (D-90일) : 총 <font color="#FF0000"><%= vt_size3 %></font>건</span></td>
    </tr>
     <tr>
        <td>&nbsp;&nbsp;&nbsp;* 차령연장용 임시검사는 차령만료일 2개월전부터 가능합니다.
             <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;임시검사후 차령만료처리를 위해서  구청방문등의 시간이 소요되오니 충분한 여유시간을 두고 처리하셔야 합니다.          
              <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차령만료일 1개월전에는 성수에 임시검사 완료여부를 확인하셔서 불이익이 없도록 주의하셔야  합니다.  
             <br>&nbsp;&nbsp;&nbsp;<font color="blue">* 차량번호옆의 아이콘을 클릭하여 검사시 특이사항을 별도로 입력하여 관리할 수 있습니다.!!!</font>                                  
        	   <br>&nbsp;&nbsp;&nbsp;* 성수자동차,<font color="red">미스터박대리(차비서)</font>에서 시행합니다. 지점은 현재방식대로 진행해주세요!!!! 
       
        </td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='12%' class='title'>상호</td>                  
                    <td width='8%' class='title'>차량번호</td>
                    <td width='6%' class='title'>의뢰일</td>
                    <td width='10%' class='title'>차명</td>
                    <td width='5%' class='title'>배기량</td>
                    <td width='7%' class='title'>등록일</td>
                    <td width='6%' class='title'>계약만료일</td>
                    <td width='6%' class='title'>차령만료일</td>              
                    <td width='6%' class='title'>차령연장<br>여부</td>
				<!--	<td width='8%' class='title'>연장상황</td> -->
					<td width='7%' class='title'>경매현황</td>
                    <td class=title width=12% >임시검사기간</td>    					
                    <td width='6%' class='title'>관리담당</td>
                    <td width='7%' class='title'>관리번호</td>
                </tr>
                
          <%if(vt_size3 > 0){
          
            		String s_end_dt = "";          
          	   	String i_end_m_60  = "";
          	             	   
				for (int i = 0 ; i < vt_size3 ; i++){
				
          	   
						Hashtable ht = (Hashtable)vt3.elementAt(i);
					
						s_end_dt = String.valueOf(ht.get("EST_CAR_END_DT"));  //차령만료예정일 	
        				i_end_m_60 = c_db.addDay(s_end_dt, -60);
					
					%>
                <tr>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>  
                    <a class=index1  href="javascript:MM_openBrWindow('car_req_master.jsp?gubun=Y&mng_id=<%=ht.get("BUS_ID2")%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>&l_cd=<%=ht.get("RENT_L_CD")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=620,height=350,left=50, top=50')"> 
                                <%=i+1%></a></td>            
                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%if(String.valueOf(ht.get("RRM")).equals("0")){%><b>(월)</b><%} %>&nbsp;<%= ht.get("FIRM_NM") %></td>

                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                      <% if ( ht.get("M1_CHK").equals("3") ) { %><font color=#ba03fe>
                      <%} else if ( ht.get("M1_CHK").equals("A") ) {%><font color=green>
                      <%} else if ( ht.get("M1_CHK").equals("6") ) {%><font color=red><%}%><%= ht.get("CAR_NO") %><% if ( ht.get("M1_CHK").equals("3")  ||  ht.get("M1_CHK").equals("6") ||  ht.get("M1_CHK").equals("A")) {%></font><% } %>
             			  <a href="javascript:cus_pre_c('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CAR_NO")%>',  '<%=ht.get("RENT_MNG_ID")%>' ,  '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='특이사항'><img src=/acar/images/center/icon_memo.gif align=absmiddle border=0></a>
              
               <!--      <a href="javascript:MM_openBrWindow('/fms2/car_board/car_board_frame.jsp?car_mng_id=<%=String.valueOf(ht.get("CAR_MNG_ID"))%>&m_id=<%=String.valueOf(ht.get("RENT_MNG_ID"))%>&l_cd=<%=String.valueOf(ht.get("RENT_L_CD"))%>&gubun=MA','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> -->
                     
                      </td>
 					 <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                     <% if(!ht.get("M1_CHK").equals("1") && !ht.get("M1_CHK").equals("2") && !ht.get("M1_CHK").equals("3") && !ht.get("M1_CHK").equals("5")  && !ht.get("M1_CHK").equals("6") && !ht.get("M1_CHK").equals("A") ) {%>
                    &nbsp;<% } else { %><%=ht.get("M1_DT")%><%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("CAR_NM")%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("DPM")%>cc</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_CAR_END_DT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                        <%if(String.valueOf(ht.get("CAR_END_YN")).equals("Y")){%>연장종료<%}%>
                    </td>
				<!--	<td align="center"><%if(ht.get("DG_YN").equals("Y")){%>처리완료<%}else if(ht.get("DG_YN").equals("N")){%><a href="javascript:dg_input('<%=ht.get("DG_NO")%>')">우편발송</a><%}else{%><%}%></td> -->
					<td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
						<%if(ht.get("OFF_LS").equals("5")){%>낙찰
					<!--	<%//}else if(ht.get("OFF_LS").equals("1")){%>매각결정 -->
						<%}else if(ht.get("OFF_LS").equals("3")){%>경매장
						<%}else if(ht.get("OFF_LS").equals("6")){%>매각
						<%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>                        	
                    <%=i_end_m_60%>~<%=ht.get("EST_CAR_END_DT")%>
                    </td>						
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("USER_NM")%></td>         
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("CAR_DOC_NO")%></td>           
		        </tr>
          <%  }
			}else{%>  
                <tr>
                    <td colspan="14" align="center">자료가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	  
    <tr> 
        <td><a name='2'></a></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운행차 <b>정기 / 정밀검사</b> 미실시 (D±30일) : 총 <font color="#FF0000"><%= cmls.size() %></font>건</span></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;* 검사유효기간/점검유효기간은 실제검사가 이루어졌던 날을 기준으로 하며, 검사기간은 최초등록일을 기준으로 산정합니다.
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;실제로 검사기간 전/후를 지나서 검사한 경우 날짜 차이가 발생되니 유념하셔서 검사기간 체크하신 후 진행하셔야 합니다.                
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;증형승합  8년이상은 6개월단위 정기,정밀이므로 <font color=red>별도</font>로 확인하셔야 합니다. 
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대형화물  5년이상은 6개월단위 정기,정밀이므로 <font color=red>별도</font>로 확인하셔야 합니다. 
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* 마스타자동차/성수자동차에 검사대행을 의뢰할 경우에는 해당 연번을 선택한 후 의뢰등록를 선택하여 수정하세요.!!</font> 
        	   <!-- <br>&nbsp;&nbsp;&nbsp;<font color="blue">* 마스타/일등전국/미스터박대리에 의뢰된 차량은 차량번호가 </font><font color=red>적색</font><font color=blue>,성수에 의뢰된 차량은 차량번호가 <font color=#ba03fe>보라색</font><font color=blue>으로 표시됩니다!! -->
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* 마스타/에프앤티/미스터박대리/차비서에 의뢰된 차량은 차량번호가 </font><font color=red>적색</font><font color=blue>,성수에 의뢰된 차량은 차량번호가 <font color=#ba03fe>보라색</font>,성서현대에 의뢰된 차량은 차량번호가 <font color=green>녹색</font><font color=blue>으로 표시됩니다!!
        	   <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;또한, 검사의뢰 요청시 아마존카와 마스타/성수자동차가 서로 원할하게 일처리를 할 수 있도록 충분한 여유시간를 두고 처리하셔야 합니다.</font>
        	   <br>&nbsp;&nbsp;&nbsp;* 담당자가 직접 검사를 하겠다고 선택할 경우 차량번호가 <font color=blue><b>파랑색</b></font> 으로 표시 됩니다.
        	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* 협력업체에 위탁하여 검사가 완료된 건은 빠른 시일내에 담당자가 반드시 검사등록을 하셔야 합니다. 검사기간 재도래시 문제가 생길 수 있습니다.</font>  
        <!--	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* 차량제작일에 따라 점검기록부 검사유효기간이 3년인 경우가 있습니다. 점검일자 확인하셔서 자동차점검 진행하셔야 합니다. 20131118 이후 점검 없어짐 -->
			   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* 차량번호옆의 아이콘을 클릭하여 검사시 특이사항을 별도로 입력하여 관리할 수 있습니다.!!!</font>     
			   <br>&nbsp;&nbsp;&nbsp;<font color=red>* 메일(<img src=/acar/images/center/e_mail.gif align=absmiddle border=0>) 아이콘을 클릭하시면 메일 전송여부를 선택하실 수 있습니다. [확인]버튼은 전송/[취소]버튼은 미전송 입니다.</font>  
			   </font>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><a href="javascript:multireg()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp; * 여러 대의 미검사 차량을 한 번에 등록하기 원할시, 해당 차량을 체크 후 등록 버튼을 누르세요. </td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%"  class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                	<td class=title width=3%>선택</td>
                    <td class=title width=3%>연번</td>
                    <td class=title width=9%>상호</td>
                    <td class=title width=6%>차량번호</td>
                     <td class=title width=5%>의뢰일</td>
                    <td width='6%' class='title'>차명</td>                    
              <!--      <td class=title width=4%>관리<br>구분</td> -->
                           <td class=title width=6%>최초등록일</td>
                    <td class=title width=6%>계약만료일</td>
                    <td class=title width=6%>등록<br>지역</td>
         
                    <td class=title width=6%>항목</td>
                    <td class=title width=11%>검사유효기간</td>    
                    <td class=title width=3%>메일</td>
                    <td class=title width=3%>문자</td>
     <!--               <td class=title width=11% >점검유효기간</td>      -->      
                    <td class=title width=10%>검사기간</td>
                    <td class=title width=5%>관리<br>담당</td>
                    <td class=title width=5%>등록</td>
                    <td class=title width=7%>관리<br>번호</td>			
                </tr>
              
          <%if(cmls.size() > 0){
          	
          	   String s_car_kd = "";
          	   String s_car_use = "";
   //       	   String s_car_use1 = "";
          	   String s_init_reg_dt = "";
          	   String s_car_ext = "";
          	   String s_gubun = "";
          	   int i_chk1 = 0;
          	   int i_chk2 = 0;
          	   int i_chk3 = 0;
          	          	          	   
          	   int i_chk2_m_30 = 0;
          	   int i_chk2_p_30 = 0;
          	   int i_chk3_m_30 = 0;
          	   int i_chk3_p_30 = 0;
          		
          	   int i_chk4 = 0;	
          	   int i_chk4_m_30 = 0;
          	   int i_chk4_p_30 = 0;
          	   	
          	   int i_f_30 = 0;
          	   int i_t_30 = 0;
          	                       	   
          	   String  s_maint_end_dt = "";
         
          	   String  ba_dt = "";
          	   String  real_dt = "";
          	   String s_car_kd_nm ="";
          	   String s_car_use_nm ="";
          	   
				for(int i = 0 ; i < cmls.size() ; i++){
					Hashtable cml = (Hashtable)cmls.elementAt(i); 
					
					s_car_kd_nm = c_db.getNameByIdCode("0041", "", String.valueOf(cml.get("CAR_KD")));
					
					if(String.valueOf(cml.get("CAR_USE")).equals("1")){
						s_car_use_nm = "렌트";
					} else if(String.valueOf(cml.get("CAR_USE")).equals("2")){
						s_car_use_nm = "리스";
					}
									
					%>
                <tr> 
                	<td align="center"><% if(!cml.get("M1_CHK").equals("1") && !cml.get("M1_CHK").equals("2") && !cml.get("M1_CHK").equals("3") && !cml.get("M1_CHK").equals("5")  && !cml.get("M1_CHK").equals("6") && !cml.get("M1_CHK").equals("8") ) {%><input type='checkbox' name='multireg' value='<%=cml.get("MNG_ID")%>^<%=cml.get("CAR_MNG_ID")%>^<%=cml.get("CAR_NO")%>^<%=cml.get("RENT_L_CD")%>^<%=cml.get("RENT_MNG_ID")%>'><%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>>                  
                    <a class=index1 href="javascript:MM_openBrWindow('car_req_master.jsp?mng_id=<%=cml.get("MNG_ID")%>&c_id=<%=cml.get("CAR_MNG_ID")%>&car_no=<%=cml.get("CAR_NO")%>&l_cd=<%=cml.get("RENT_L_CD")%>&m_id=<%=cml.get("RENT_MNG_ID")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=620,height=350,left=50, top=50')">
                    <%= i+1 %></a></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                    	<a href="javascript:view_client('<%=cml.get("RENT_MNG_ID")%>','<%=cml.get("RENT_L_CD")%>','<%=cml.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true">
                    	<%if(!String.valueOf(cml.get("RRM")).equals("0")){%><b>(월)&nbsp;</b><%} %><%= cml.get("FIRM_NM") %>
        			<%if(!String.valueOf(cml.get("CONT_DT")).equals("")){%>:오프리스
        			<%}else{%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("1")){%>:매각결정<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("3")){%>:경매장<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("5")){%>:낙찰<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("6")){%>:매각<%}%>			  			  			  
        			<%}%>  
        		</a>     		
        			</td>
        			
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>><span title='<%=s_car_kd_nm%>:<%=s_car_use_nm%>'>
                    <% if ( cml.get("M1_CHK").equals("1") || cml.get("M1_CHK").equals("5")  || cml.get("M1_CHK").equals("6") || cml.get("M1_CHK").equals("8")  ) { %><font color=red><%}else if ( cml.get("M1_CHK").equals("A") ) { %><font color=green><%}else if ( cml.get("M1_CHK").equals("2") ) { %><font color=blue><%}else if ( cml.get("M1_CHK").equals("3") ) { %><font color=#ba03fe><%}%><%= cml.get("CAR_NO") %><% if ( cml.get("M1_CHK").equals("1")  || cml.get("M1_CHK").equals("2") || cml.get("M1_CHK").equals("3") || cml.get("M1_CHK").equals("5") || cml.get("M1_CHK").equals("6")  || cml.get("M1_CHK").equals("8") || cml.get("M1_CHK").equals("A") ) {%></font><% } %>
                    </span>
           <!--         <a href="javascript:MM_openBrWindow('/fms2/car_board/car_board_frame.jsp?car_mng_id=<%=String.valueOf(cml.get("CAR_MNG_ID"))%>&m_id=<%=String.valueOf(cml.get("RENT_L_CD"))%>&l_cd=<%=String.valueOf(cml.get("RENT_L_CD"))%>&gubun=MA','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> -->
                    	  <a href="javascript:cus_pre_c('<%=cml.get("CAR_MNG_ID")%>', '<%=cml.get("CAR_NO")%>',  '<%=cml.get("RENT_MNG_ID")%>' ,  '<%=cml.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='특이사항'><img src=/acar/images/center/icon_memo.gif align=absmiddle border=0></a>
                    </td>
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>>
                     <% if(!cml.get("M1_CHK").equals("1") && !cml.get("M1_CHK").equals("2") && !cml.get("M1_CHK").equals("3") && !cml.get("M1_CHK").equals("5")  && !cml.get("M1_CHK").equals("6") && !cml.get("M1_CHK").equals("8") && !cml.get("M1_CHK").equals("A") ) {%>
                    &nbsp;<% } else { %><%=cml.get("M1_DT")%><%}%></td>
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("CAR_NM") %></td>
                 <!--    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("RENT_WAY") %></td> -->
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>>
						<a href="javascript:view_car('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'>
							<%= AddUtil.ChangeDate2((String)cml.get("INIT_REG_DT")) %>
						</a>
					</td>
					
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%= AddUtil.ChangeDate2((String)cml.get("RENT_END_DT")) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%=c_db.getNameByIdCode("0032", "", String.valueOf(cml.get("CAR_EXT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>>
        <%
        			s_car_kd  = String.valueOf(cml.get("CAR_KD")); //승용차, 승합차 등 구분
        			s_car_use = String.valueOf(cml.get("CAR_USE"));  //사업용, 업무용
        		//	s_car_use1 = String.valueOf(cml.get("CAR_USE1"));  //용도변경 check
        			s_init_reg_dt = String.valueOf(cml.get("INIT_REG_DT"));  //최초등록일
        			s_car_ext = String.valueOf(cml.get("CAR_EXT"));  //지역  
        			//점검은 만기(test_end_dt)가 20131118일 이후는 점검면제됨 -20131218
        		//	s_gubun = "";
        			s_maint_end_dt = String.valueOf(cml.get("MAINT_END_DT")); //검사유효기간 만기일
        			        		        		       			
        			real_dt = s_maint_end_dt;
        			
        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
        			if (AddUtil.parseInt(ba_dt) < AddUtil.parseInt( s_maint_end_dt )) {
	        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
       					real_dt = ba_dt;
       				}
					
        			//사업용 - '허'로 일단 구분
        			if ( s_car_use.equals("1")) {
        			      				         					
        				i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,24), -1));
        				i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,36), -1));
        				i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        				i_chk4= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,72), -1)); //중협승합인 경우  8년까지 1년검사 그후 6개월마다 검사 
        				        								
        				i_chk2_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        						
        				i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
        				
        				i_chk4_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk4), -60));
        				i_chk4_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk4), 60));
        			       			      				
        															
	        			if (s_car_ext.equals("2") ||  s_car_ext.equals("6")  ||  s_car_ext.equals("7") )  { //파주 ,  인천은 정밀 없음
	        				    s_gubun = "정기";
	        		
	        				     if (  AddUtil.getDate2(4) > i_chk3) {          				  		   
	        					   s_gubun = "정기";
	        				      } else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
	        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {        				
	        					           s_gubun = "정기";   
	        					   } else {
	        					   	 s_gubun = "정기";   
	        					   }
	        				      } else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
	        					    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
	        					         s_gubun = "정기";   
	        					   } else {
	        					   	 s_gubun = "정기";   
	        					   } 
	        				      } else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        					   s_gubun = "정기";
	        				      }		        					
	        				      					
	        			} else {  //파주포천이 아니면
	        			    	    s_gubun = "정기";
		        			
		        					if (  AddUtil.getDate2(4) > i_chk3 ) {
		        					   s_gubun = "정기+정밀";
		        					} else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
		        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {
		        					     s_gubun = "정기+정밀";   
		        					   } else {
		        					   	 s_gubun = "정기+정밀";   
		        					   }
		        					} else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
		        					    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
		        					     s_gubun = "정기+정밀";   
		        					   } else {
		        					   	 s_gubun = "정기";   
		        					   } 
		        					} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
		        					   s_gubun = "정기";
		        					}		        					
		        				
	        			 }
        			}else {   //리스
        			
        			  //승용차 - 대형화물 : s_car_kd :8 , s_car_kd:4 중형승합 
        				if ( s_car_kd.equals("1") || s_car_kd.equals("2") || s_car_kd.equals("3") || s_car_kd.equals("9") ) { //승용차 
        					i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,72), -1));
        					        					        					
        				} else {
        					i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,12), -1));
        					i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					
        					if ( s_car_kd.equals("8") ) { 
        						i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,60), -1));
        					} else if ( s_car_kd.equals("4") ) {
        						i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,96), -1));
        					}
        				} 
        				
        				i_chk2_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        				
        				if ( s_car_kd.equals("8") ) { 
	        				i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
	        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
        				} else if ( s_car_kd.equals("4") ) {
        					 i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -96));
	        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 96));
        				}
        				         				        			        			     			       			
        				if (s_car_ext.equals("2")|| s_car_ext.equals("6")|| s_car_ext.equals("7"))  { //파주 , 포천은 정밀 없음
        				   	if (  AddUtil.getDate2(4) > i_chk2) {
        					   s_gubun = "정기";
        					}else if (  AddUtil.getDate2(4) > i_chk1) {
        					   s_gubun = "정기";
        					} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        				   s_gubun = "정기";
	        				} 
        				} else { //파주, 포천이 아니면
        				   	if (  AddUtil.getDate2(4) > i_chk2 ) {
	        				   s_gubun = "정기+정밀";
	        				} else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
	        				    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
	        				     s_gubun = "정기+정밀";   
	        				   } else {
	        				   	 s_gubun = "정기";   
	        				   } 
	        				} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        				   s_gubun = "정기";
	        				}
        					
        				}
        					
        			}    
        		
        %>            
                   <%=s_gubun%>
                    </td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= cml.get("MAINT_ST_DT") %>~<%= cml.get("MAINT_END_DT") %></td>
					<td align="center">
						<a href="javascript:view_email('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차 정기검사 안내 메일'><img src=/acar/images/center/e_mail.gif align=absmiddle border=0></a>
					</td>
        			<td align="center">
						<a href="javascript:view_sms('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>', '<%=cml.get("CAR_NO")%>')" onMouseOver="window.status=''; return true" title='자동차 정기검사 안내 문자'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a>
					</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= c_db.addDay(real_dt,-30) %>~<%= c_db.addDay(real_dt,30) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>><%= c_db.getNameById((String)cml.get("MNG_ID"),"USER") %>
                 
        			</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)      ) out.print("style='background-color:fff799;'"); %>><a href="javascript:go_cus_reg_maint('<%= cml.get("CAR_NO") %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= cml.get("CAR_DOC_NO") %></td>			
                </tr>
          <% 	}
		  	}else{ %>
                <tr> 
                    <td colspan="17" align="center">운행차 정기 / 정밀검사 예정이 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
    <tr> 
        <td><a name='3'></a></td>
    </tr>  

</table>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
