<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.car_register.*"%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.car_mst.*, acar.short_fee_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"	       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//사고관리일련번호
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");//고객관리번호
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	String bus_id2 	= "";
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//CAR_NM : 차명정보
	cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	if(client_id.equals("")) client_id = String.valueOf(cont.get("CLIENT_ID"));
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
	
	String ins_use_st = ma_bean.getIns_use_st();
    	if(ins_use_st.length() > 7){
    		ins_use_st 	= ins_use_st.substring(0,8);
    	}
  
  String jg_b_dt = e_db.getVar_b_dt("jg", ins_use_st);
   
  //잔가변수NEW
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);  
	
	String section = cm_bean.getSection();
	
	if(!ej_bean.getJg_r().equals(""))	section = ej_bean.getJg_r();
    	
	ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(section, "2", ins_use_st);
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_bean 	= crd.getCarChangeLast(c_id, String.valueOf(cont.get("CAR_NO")), "", "");
	
	//청구서발행 조회
	TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(c_id, accid_id, seq_no, ma_bean.getIns_req_amt());
	
	String print_type 	= "O";
	String file_type 	= "";
	String file_path 	= "";
	String file_name 	= "";
	String scan_cont_yn	= "";
	
	String ment1	= "";
	String ment2	= "";
	String ment3	= "";
	String ment4	= "";
	
	String cust_id	= "";
	String cust_st	= "";
	
	int s=0;
	String value[] = new String[11];
	
	if(!ma_bean.getApp_docs().equals("")){
		StringTokenizer st = new StringTokenizer(ma_bean.getApp_docs(),"^");
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
	}else{
		for(int i=0; i<11; i++){
			value[i] = "N";
		}
	}
	
	
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
				
	String content_code = "";
	String content_seq  = "";
  	String file_st = "";
        String file_rent_st = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;		
	
	
	String res_car_id	= "";	
	String res_car_no	= "";	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;

		
	//팝업윈도우 열기
	function MM_openBrWindow_Doc(theURL) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
		popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		popObj.location = theURL;
		popObj.focus();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow_Doc2(theURL) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		popObj.location = theURL;
		popObj.focus();	
	}

			

		
	//예약시스템 계약서
	function view_scan_res(mode, c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_accid_print_2014.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode="+mode+"&sub_c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&l_cd=<%=l_cd%>", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
					
	//예약시스템 임의 계약서
	function view_scan_res_im(c_id){
		var fm = document.form1;
		if(fm.cust_id.value == ''){
			window.open("/acar/rent_mng/res_rent_u_accid_im_print_2014.jsp?c_id="+c_id+"&mode=accid_doc&sub_c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&client_id=<%=client_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
		}else{
			window.open("/acar/rent_mng/res_rent_u_accid_im_print_2014.jsp?c_id="+c_id+"&mode=accid_doc&sub_c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&client_id="+fm.cust_id.value+"&client_st="+fm.cust_st.value+"&m_id=<%=m_id%>&l_cd=<%=l_cd%>", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");				
		}
	}

	//견적서인쇄
	function DocPrint(){
		var fm = document.form1;
		var SUBWIN="/tax/item_mng/doc_accid_print_t.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>";	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}	
	
	//세금계산서인쇄
	function TaxPrint(){
		var fm = document.form1;
		var SUBWIN="/tax/tax_mng/tax_accid_print_t.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>";	
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
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
	
	//선택출력
	function Accid_ReqDoc_Print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("인쇄할 문서를 선택하세요.");
			return;
		}	
		
		if(confirm('청구서류를 선택 인쇄하시겠습니까?')){
			fm.target = "_blank";
			fm.action = "myaccid_reqdoc_select_print.jsp";
			fm.submit();	
		}
	}		
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}		
			

//-->
</script>
</head>
<body>
<form action="" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>    
<input type="hidden" name="seq_no" value="<%=seq_no%>">  	
<input type="hidden" name="client_id" value="<%=client_id%>">
<input type="hidden" name="section" value="<%=cm_bean.getSection()%>">
<input type="hidden" name="ins_use_st" value="<%=ins_use_st%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
	<td colspan=6>
	    <table width=100% border=0 cellpadding=0 cellspacing=0>
		<tr>
		    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > </span><span class=style5>
			<%if(ma_bean.getIns_req_gu().equals("1")){%>휴차료<%}else{%>대차료<%}%> 청구시 필요서류</span>
		    </td>
		    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
		</tr>
	    </table>
	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>  
    <tr>
	<td class=h></td>
    </tr>  
    <tr>
	<td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">계약번호</td>
                    <td width="40%">&nbsp;<%=l_cd%></td>
                    <td class=title width="10%">상호</td>
                    <td width="40%">&nbsp;<%=cont.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>사고일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(a_bean.getAccid_dt())%></td>
                    <td class=title>사고경위</td>
                    <td>&nbsp;<%=a_bean.getAccid_cont()%></td>
                </tr>				
                <tr> 
                    <td class=title>사고차량</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%> (<%=c_id%>) </td>
                    <td class=title>대차차량</td>
                    <td>&nbsp;<%=ma_bean.getIns_car_no()%>&nbsp;<%=ma_bean.getIns_car_nm()%></td>
                </tr>	
            </table>
        </td>
    </tr>	
    <tr>
	<td class=h></td>
    </tr>	
    <tr>
        <td align="right"><a href="javascript:view_scan('<%=m_id%>','<%=l_cd%>');" class="btn"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="5%" class=title>연번</td>					
                    <td width="5%" class=title><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>					
                    <td width="35%" class=title>내용</td>
                    <td width="35%" class=title>비고</td>					
                    <td width="10%" class=title>파일</td>					
                    <td width="5%" class=title>묶음</td>
                    <td width="5%" class=title>개별</td>
                </tr>
                
		<%int idx = 0;%>
		
		<%idx++;%>
		<!--사업자등록증-->
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="D01" <%if(from_page.equals("/fms2/accid_doc/accid_mydoc_mng_c.jsp")){%>checked<%}%>></td>				
                    <td>&nbsp;아마존카 사업자등록증</td>
                    <td align="center"></td>				  
                    <td align="center">.jpg</td>				  				  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('사업자등록증.jpg')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D01_file" value="/data/doc/사업자등록증.jpg">
		    </td>
                </tr>
                
		<%idx++;%>
		<!--단기대여요금표-->
		<%
			String file_name2 = "아마존카_단기대여_요금표.jpg";
		
			if(sf_bean.getReg_dt().equals("20090115"))  file_name2 = "아마존카_단기대여_요금표_20090115.jpg";
			if(sf_bean.getReg_dt().equals("20111001"))  file_name2 = "아마존카_단기대여_요금표_20111001.jpg";
			if(sf_bean.getReg_dt().equals("20131224"))  file_name2 = "아마존카_단기대여_요금표_20131224.jpg";
			if(sf_bean.getReg_dt().equals("20150101"))  file_name2 = "아마존카_단기대여_요금표_20150101.jpg";
			if(sf_bean.getReg_dt().equals("20190709"))  file_name2 = "아마존카_단기대여_요금표_20190709.jpg";		//20190708
			if(sf_bean.getReg_dt().equals("20211027"))  file_name2 = "아마존카_단기대여_요금표_20211027.jpg";
		%>		
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="D02" <%if(from_page.equals("/fms2/accid_doc/accid_mydoc_mng_c.jsp")){%>checked<%}%>></td>				
                    <td>&nbsp;아마존카 단기대여요금표</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('<%=file_name2%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D02_file" value="/data/doc/<%=file_name2%>">
		    </td>
                </tr>
                
		<%idx++;%>
		<!--통장사본-->
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="D03" <%if(from_page.equals("/fms2/accid_doc/accid_mydoc_mng_c.jsp")){%>checked<%}%>></td>				
                    <td>&nbsp;아마존카 신한은행 통장사본</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('아마존카_통장사본.jpg')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D03_file" value="/data/doc/아마존카_통장사본.jpg">
		    </td>
                </tr>			
                
		<%idx++;%>
		<!--1심 판결문-->
                <tr>
                    <td align="center" rowspan='3'><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="D04" <%if(s>0 && value[9].equals("Y"))%>checked<%%>></td>				
                    <td>&nbsp;대차료청구소송 1심판결문 1page</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('page-1.jpg')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D04_file" value="/data/doc/page-1.jpg">
		    </td>
                </tr>			                
                <tr>                  
                    <td align="center"><input type="checkbox" name="ch_cd" value="D05" <%if(s>0 && value[9].equals("Y"))%>checked<%%>></td>				
                    <td>&nbsp;대차료청구소송 1심판결문 2page</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('page-2.jpg')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D05_file" value="/data/doc/page-2.jpg">
		    </td>
                </tr>			
                <tr>                  
                    <td align="center"><input type="checkbox" name="ch_cd" value="D06" <%if(s>0 && value[9].equals("Y"))%>checked<%%>></td>				
                    <td>&nbsp;대차료청구소송 1심판결문 3page</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc('page-3.jpg')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D06_file" value="/data/doc/page-3.jpg">
		    </td>
                </tr>		
		
		<%idx++;%>
		<!--2심 판결문-->
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="D07" <%if(s>10 && value[10].equals("Y"))%>checked<%%>></td>				
                    <td>&nbsp;대차료청구소송 2심판결문 1~14page</td>
                    <td align="center"></td>	
                    <td align="center">.jpg</td>				  				  			  
                    <td align="center">O</td>
                    <td align="center">
                        <a href="javascript:MM_openBrWindow_Doc2('2011나10012보험금판결서.pdf')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="D07_file" value="/data/doc/2011나10012보험금판결서.pdf">
		    </td>
                </tr>		                	
                
		<tr>
		    <td colspan="7"  class=line2></td>
		</tr>		
		
		
							
		<%if(String.valueOf(cont.get("CAR_ST")).equals("2")){//보유차
		
			//단기계약정보
			RentContBean rc_bean = rs_db.getRentContCase2(a_bean.getRent_s_cd());
			if(!rc_bean.getRent_s_cd().equals("")){
				print_type 	= "O";
				file_type 	= ".jsp";
				file_path 	= "";
				cust_id		= rc_bean.getCust_id();
				cust_st		= rc_bean.getCust_st();
                %>															
		<%	idx++;%>
		<!--사고차량(보유차) 서비스 계약서-->
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="LCO" <%if(s>0 && value[3].equals("Y")){%>checked<%}%>></td>				
                    <td>&nbsp;사고차량(보유차) 서비스 계약서</td>
                    <td>&nbsp;[<%=cont.get("CAR_NO")%>]
		        <%if(rc_bean.getRent_st().equals("1")){%>
                        단기대여 
                        <%}else if(rc_bean.getRent_st().equals("2")){%>
                        정비대차 
                        <%}else if(rc_bean.getRent_st().equals("3")){%>
                        사고대차 
                        <%}else if(rc_bean.getRent_st().equals("9")){%>
                        보험대차 
                        <%}else if(rc_bean.getRent_st().equals("10")){%>
                        지연대차 		
                        <%}else if(rc_bean.getRent_st().equals("4")){%>
                        업무대여 
                        <%}else if(rc_bean.getRent_st().equals("5")){%>
                        업무지원 
                        <%}else if(rc_bean.getRent_st().equals("6")){%>
                        차량정비 
                        <%}else if(rc_bean.getRent_st().equals("7")){%>
                        차량점검 
                        <%}else if(rc_bean.getRent_st().equals("8")){%>
                        사고수리 
                        <%}else if(rc_bean.getRent_st().equals("9")){%>
                        기타 
                        <%}else if(rc_bean.getRent_st().equals("12")){%>
                        월렌트
                        <%}%>
		    </td>		
                    <td align="center"><%=file_type%></td>				  				  			  
                    <td align="center"><%=print_type%></td>
                    <td align="center">
                        <a href="javascript:view_scan_res('res_doc','<%=rc_bean.getCar_mng_id()%>','<%=rc_bean.getRent_s_cd()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		        <input type="hidden" name="LCO_cid"  value="<%=rc_bean.getCar_mng_id()%>">					
		        <input type="hidden" name="LCO_scd"  value="<%=rc_bean.getRent_s_cd()%>">
		        <input type="hidden" name="LCO_rent_st"  value="<%=rc_bean.getRent_st()%>">					
		    </td>
                </tr>					
		<%	}%>
				
		<%}else{//장기계약%>
		
		<!--대여개시후계약서(앞)-jpg파일-->			
                <% 	
                	file_rent_st = Integer.toString(fee_size);
                	file_st = "17";                   	
                	content_code = "LC_SCAN";
                	content_seq  = m_id+""+l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
                		idx++;
                		scan_cont_yn = "Y";
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="S17" <%if(s>0 && value[3].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;사고차량 대여개시후계약서(앞)</td>
		    <td align="center">[<%=cont.get("CAR_NO")%>]</td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="S17_seq"  value="<%=ht.get("SEQ")%>">
			<input type="hidden" name="S17_name" value="<%=ht.get("FILE_NAME")%>">
			<input type="hidden" name="S17_path" value="<%=ht.get("SAVE_FOLDER")%>">
			<input type="hidden" name="S17_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="S17_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%		}%>		
		<%	}%>		
		
		<!--대여개시후계약서(뒤)-jpg파일-->			
                <% 	
                	file_rent_st = Integer.toString(fee_size);
                	file_st = "18";                   	
                	content_code = "LC_SCAN";
                	content_seq  = m_id+""+l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
                		idx++;
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="S18" <%if(s>0 && value[3].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;사고차량 대여개시후계약서(뒤)</td>
		    <td align="center">[<%=cont.get("CAR_NO")%>]</td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="S18_seq"  value="<%=ht.get("SEQ")%>">
			<input type="hidden" name="S18_name" value="<%=ht.get("FILE_NAME")%>">
			<input type="hidden" name="S18_path" value="<%=ht.get("SAVE_FOLDER")%>">
			<input type="hidden" name="S18_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="S18_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%		}%>		
		<%	}%>
		
		
		<%	if(!scan_cont_yn.equals("Y")){%>
		<!--최초계약서-->			
                <% 	
                	file_rent_st = Integer.toString(fee_size);
                	file_st = "1";                   	
                	content_code = "LC_SCAN";
                	content_seq  = m_id+""+l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
                		idx++;
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="S01" <%if(s>0 && value[3].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;사고차량 최초계약서</td>
		    <td align="center">[<%=cont.get("CAR_NO")%>]</td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="S01_seq"  value="<%=ht.get("SEQ")%>">
			<input type="hidden" name="S01_name" value="<%=ht.get("FILE_NAME")%>">
			<input type="hidden" name="S01_path" value="<%=ht.get("SAVE_FOLDER")%>">
			<input type="hidden" name="S01_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="S01_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%		}%>		
		<%	}%>				
		<%	}%>					
							
		<%}//장기계약%>						
				
				
		<!--자동차등록증-->			
                <% 	
                	content_code = "CAR_CHANGE";
                	content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
                
                	if(!content_seq.equals("")){
                		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	}
                	
                	if(attach_vt_size > 0){                		
						for (int j = 0 ; j < 1 ; j++){
 							Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 							//if(j+1==attach_vt_size){ //마지막 등로증
 								idx++;
                %>                
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="LCA" <%if(s>0 && value[4].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;사고차량 자동차등록증</td>
		    <td align="center">[<%=cont.get("CAR_NO")%>]
		        &nbsp;<%=ch_bean.getCha_dt()%>
			<% if(ch_bean.getCha_cau().equals("1")){%>
                            사용본거지 변경 
                        <%}else if(ch_bean.getCha_cau().equals("2")){%>
                            용도변경 
                        <%}else if(ch_bean.getCha_cau().equals("3")){%>
                            기타 
                        <%}else if(ch_bean.getCha_cau().equals("4")){%>
                            없음
                        <%}else if(ch_bean.getCha_cau().equals("5")){%>
			    신규등록
			<%}%>
		    </td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="LCA_cid"  value="<%=ch_bean.getCar_mng_id()%>">
			<input type="hidden" name="LCA_seq"  value="<%=ch_bean.getCha_seq()%>">
			<input type="hidden" name="LCA_name" value="<%=ht.get("FILE_NAME")%>">
			<input type="hidden" name="LCA_path" value="<%=ht.get("SAVE_FOLDER")%>">
			<input type="hidden" name="LCA_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="LCA_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%			//}%>		
    		<%		}%>		    		
		<%	}%>	
								

				
				
		<%	if(!ma_bean.getIns_car_no().equals("")){
				ch_bean = crd.getCarChangeLast("", ma_bean.getIns_car_no(), ma_bean.getIns_car_nm(), ma_bean.getIns_use_st());
				file_type = ".jsp";
				print_type	= "O";
				if(!ch_bean.getCar_mng_id().equals("")){
					//단기계약정보
					RentContBean rc_bean = rs_db.getRentContCaseAccid2(ch_bean.getCar_mng_id(), accid_id);
					if(!rc_bean.getRent_s_cd().equals("")){
						res_car_id = rc_bean.getCar_mng_id();
						file_type = ".jsp";
		%>
		<%idx++;%>
                <tr>
                  <td align="center"><%=idx%></td>
                  <td align="center"><input type="checkbox" name="ch_cd" value="SCO" <%if(s>0 && value[5].equals("Y")){%>checked<%}%>></td>				
                  <td>&nbsp;대차차량 사고대차 서비스 계약서</td>
                  <td>&nbsp;[<%=ma_bean.getIns_car_no()%>]
				    <%if(rc_bean.getRent_st().equals("1")){%>
                    단기대여 
                    <%}else if(rc_bean.getRent_st().equals("2")){%>
                    정비대차 
                    <%}else if(rc_bean.getRent_st().equals("3")){%>
                    사고대차 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    보험대차 
                    <%}else if(rc_bean.getRent_st().equals("10")){%>
                    지연대차 		
                    <%}else if(rc_bean.getRent_st().equals("4")){%>
                    업무대여 
                    <%}else if(rc_bean.getRent_st().equals("5")){%>
                    업무지원 
                    <%}else if(rc_bean.getRent_st().equals("6")){%>
                    차량정비 
                    <%}else if(rc_bean.getRent_st().equals("7")){%>
                    차량점검 
                    <%}else if(rc_bean.getRent_st().equals("8")){%>
                    사고수리 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    기타 
                    <%}else if(rc_bean.getRent_st().equals("12")){%>
                    월렌트
                    <%}%>
		  </td>		
                  <td align="center"><%=file_type%></td>				  				  			  
                  <td align="center"><%=print_type%></td>
                  <td align="center">
                      <a href="javascript:view_scan_res('accid_doc','<%=rc_bean.getCar_mng_id()%>','<%=rc_bean.getRent_s_cd()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		      <input type="hidden" name="SCO_cid"  value="<%=rc_bean.getCar_mng_id()%>">					
		      <input type="hidden" name="SCO_scd"  value="<%=rc_bean.getRent_s_cd()%>">
		  </td>
                </tr>	
		<%			}else{
						ment1 = "대차차량에 대한 사고대차 서비스 계약이 등록되어 있지 않습니다. 임의계약서이니 참고하세요.";%>
		<%idx++;%>
                <tr>
                  <td align="center"><%=idx%></td>
                  <td align="center"><input type="checkbox" name="ch_cd" value="SCI" <%if(s>0 && value[5].equals("Y")){%>checked<%}%>></td>				
                  <td>&nbsp;대차차량 계약서</td>
                  <td>&nbsp;[<%=ma_bean.getIns_car_no()%>] 임의계약서</td>		
                  <td align="center"><%=file_type%></td>				  				  			  
                  <td align="center"><%=print_type%></td>
                  <td align="center">
                        <a href="javascript:view_scan_res_im('<%=ch_bean.getCar_mng_id()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
			<input type="hidden" name="SCI_cid"  value="<%=ch_bean.getCar_mng_id()%>">									  
                </tr>					
		<%			}%>
		<%		}%>
		
		<%
				CarHisBean res_ch_bean = new CarHisBean();
				Hashtable reserv = new Hashtable();
			
				if(!res_car_id.equals("")){
					reserv = rs_db.getCarInfo(res_car_id);						
					res_ch_bean 	= crd.getCarChangeLast(res_car_id, String.valueOf(reserv.get("CAR_NO")), "", "");
				}
		%>
		
		<!--대차차량 자동차등록증-->				
                <% 	
                		content_code = "CAR_CHANGE";
                		content_seq  = res_ch_bean.getCar_mng_id()+""+res_ch_bean.getCha_seq();
                		
                		if(!content_seq.equals("")){
                			attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                			attach_vt_size = attach_vt.size();
                		}
                	
                		if(attach_vt_size > 0){                		
							for (int j = 0 ; j < 1 ; j++){
 								Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 								//if(j+1==attach_vt_size){ //마지막 등로증
 									idx++;
                %>                
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="SCA" <%if(s>0 && value[6].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;대차차량 자동차등록증</td>
		    <td align="center">[<%=reserv.get("CAR_NO")%>]
		        &nbsp;<%=res_ch_bean.getCha_dt()%>
			<% if(res_ch_bean.getCha_cau().equals("1")){%>
                            사용본거지 변경 
                        <%}else if(res_ch_bean.getCha_cau().equals("2")){%>
                            용도변경 
                        <%}else if(res_ch_bean.getCha_cau().equals("3")){%>
                            기타 
                        <%}else if(res_ch_bean.getCha_cau().equals("4")){%>
                            없음
                        <%}else if(res_ch_bean.getCha_cau().equals("5")){%>
			    신규등록
			<%}%>
		    </td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="SCA_cid"  value="<%=res_ch_bean.getCar_mng_id()%>">
			<input type="hidden" name="SCA_seq"  value="<%=res_ch_bean.getCha_seq()%>">
			<input type="hidden" name="SCA_name" value="<%=ht.get("FILE_NAME")%>">
			<input type="hidden" name="SCA_path" value="<%=ht.get("SAVE_FOLDER")%>">
			<input type="hidden" name="SCA_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="SCA_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%				//}%>		
    		<%			}%>		    		
		<%		}%>			

		<%	}else{
				ment4 = "등록된 대차차량이 없습니다.";%>
		<%	}%>
						
						
		<!--거래명세서-->
		<%	if(!ti.getCar_mng_id().equals("")){%>																				
		<%		idx++;%>
                <tr>
                    <td align="center"><%=idx%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="ITE" <%if(s>0 && value[7].equals("Y")){%>checked<%}%>></td>				
                    <td>&nbsp;<%if(ma_bean.getIns_req_gu().equals("1")){%>휴차료<%}else{%>대차료<%}%> 거래명세서</td>
                    <td align="center"></td>				  
                    <td align="center">jsp</td>				  				  		  
                    <td align="center">O</td>
                    <td align="center">
                  	<a href="javascript:DocPrint()"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
			<input type="hidden" name="ITE_item_id"  value="<%=ti.getItem_id()%>">
		    </td>
                </tr>	
		<%	}else{
				ment3 = "발행된 청구서가 없습니다.";%>	
		<%	}%>
		
		
                
                <!--대차차량 계약서 스캔파일-->
		<%
			content_code = "PIC_RESRENT_ACCID";
			content_seq  = c_id+""+accid_id+""+seq_no;

			attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			attach_vt_size = attach_vt.size();					        
		%>
		<%	idx++;%>		
		<%	if(attach_vt_size > 0){%>
		<%		for (int i = 0 ; i < attach_vt_size ; i++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(i);
    		%>		
		<tr>
		    <td align="center"><%=idx%></td>
		    <td align="center"><input type="checkbox" name="ch_cd" value="SCN2" <%if(s>0 && value[8].equals("Y")){%>checked<%}%>></td>				
		    <td>&nbsp;대차차량 계약서 스캔파일</td>
		    <td align="center"></td>				  
		    <td align="center"><%=ht.get("FILE_TYPE")%></td>				  				  		  
		    <td align="center">O</td>
		    <td align="center">
		        <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>
			<input type="hidden" name="SCN2_item_id"  value="">
			<input type="hidden" name="SCN2_path" value="">
			<input type="hidden" name="SCN2_type" value="<%=ht.get("FILE_TYPE")%>">
			<input type="hidden" name="SCN2_file" value="<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>">
		    </td>
		</tr>    					
    		<%		}%>		
		<%	}%>	
		
					        
			        
	    </table>
	</td>
    </tr>	
    <tr>
        <td colspan="2">☞ 묶음인쇄가 X 인 것은 개별에서 보기를 클릭하여 팝업된 페이지에서 인쇄 혹은 저장해서 업무처리하세요</td>
    </tr>	
	<%if(!ment1.equals("")){%>	
    <tr>
        <td colspan="2">☞ <font color=red><%=ment1%></font></td>
    </tr>		
	<%}%>
	<%if(!ment2.equals("")){%>	
    <tr>
        <td colspan="2">☞ <font color=red><%=ment2%><br>
		&nbsp;&nbsp;&nbsp; (동급차량을 대차해야 하나, 보유차가 충분하지 못한 관계로 대차차량은 임의로 등록가능하도록 하였습니다. 그래서 자동차등록증 연결이 안맞을수도 있습니다.)</font></td>
    </tr>		
	<%}%>	
	<%if(!ment3.equals("")){%>	
    <tr>
        <td colspan="2">☞ <%=ment3%></td>
    </tr>		
	<%}%>	
    <tr>
        <td colspan="2">☞ 문의는 전산팀에게 해주세요.</td>
    </tr>	
	<tr>
		<td align="center">
		  <a href="javascript:Accid_ReqDoc_Print()"><img src='/acar/images/button_print.gif' border=0></a>
		  </td>
	</tr>  	
</table>
<input type="hidden" name="cust_id" value="<%=cust_id%>">
<input type="hidden" name="cust_st" value="<%=cust_st%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
