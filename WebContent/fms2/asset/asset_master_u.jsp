<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetMaBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String asset_g 	= request.getParameter("asset_g")==null?"1":request.getParameter("asset_g");
	
	//자산 정보 
	AssetDatabase a_db = AssetDatabase.getInstance();
	bean = a_db.getAssetMa(asset_code);
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	Vector vt = new Vector();
	
	vt = a_db.getAssetSaleList(chk1, st_dt,end_dt,"", "", asset_code, "", "");

	int cont_size = vt.size();
	
	long t1=0;
	long t2=0;
	long t3=0;
	long t4=0;
	long t5=0;
	long t6=0;
	long t7=0;
	long t8=0;
	long t9=0;
	long s1=0; //매각액
	float f_sup_amt = 0;
	long sup_amt = 0;
	
	long t12=0; //구매보조금
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--		
	//목록보기
	function go_list(asset_g){
		if ( asset_g == '5' ){
			parent.location='asset_s5_frame.jsp?chk1=<%=chk1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&asset_code=<%=asset_code%>&st=<%=st%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>';
		} else {
			parent.location='asset_s_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&asset_code=<%=asset_code%>&st=<%=st%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>';
		}
	}
	
	
	function OpenMove(){
	   var theForm = document.form1;
	   var url = "asset_move_s_sc.jsp?gubun2=5&asset_code=<%=asset_code%>&sh_height=400";		
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	}
	
	function OpenDep(){
	   var theForm = document.form1;
	   var url = "asset_dep_s_sc.jsp?gubun2=5&asset_code=<%=asset_code%>&sh_height=400";		
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	}
	
	function RegMove(yn){
	   var theForm = document.form1;
	   
	   if (yn != '2' ) {
		   alert("상각진행중인 자산만 변동등록할 수 있습니다.");
		   return;
	   }	
	   
	   var url = "asset_move_reg.jsp?gubun2=5&asset_code=<%=asset_code%>&sh_height=400";		
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	}	
		
	function RegMove3(yn){
	   var theForm = document.form1;
	   
	   if (yn == '2' || yn == '4' ) {	   
	   } else {
		   alert("상각진행중, 상각완료된 자산만 폐기등록할 수 있습니다.");
		   return;
	   }	
	   
	   var url = "asset_move_reg3.jsp?gubun2=5&asset_code=<%=asset_code%>&sh_height=400";		
			   	
	   theForm.action = url;
	   theForm.target = "c_foot";
	   theForm.submit();
	}

	
	function RegMove4(yn){
	   var theForm = document.form1;
	   
	   if (yn != '5' ) {
		   alert("매각/폐기된 자산만 복원할 수 있습니다. 당해년도 자본적 지출 데이타 확인후 처리!!!  매각은 관련 table 수정필수 !!  sui, auction ...");
		   return;
	   }	
		
		if(!confirm('자산 복원 하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "asset_yn_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	
	
	
	function RegMove5(yn){
	   var theForm = document.form1;
	   
	   if (yn != '5' ) {
		   alert("매각/폐기된 자산만 복원할 수 있습니다. 당해년도 자본적 지출 데이타 확인후 처리!!!  매각은 관련 table 수정필수 !!  sui, auction ...");
		   return;
	   }	
		
		if(!confirm('자산처리 취소 하시겠습니까?')){	return;	}
		theForm.cmd.value = "ud";
		theForm.action = "asset_master_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	

	function save(yn){
	
		var theForm = document.form1;
		if (yn != '2' ) {
		   alert("상각진행중인 자산만 수정할 수 있습니다.");
		   return;
		}	
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "asset_master_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	
	function del(yn){
			
		var theForm = document.form1;
		if (yn != '2' ) {
		   alert("상각진행중인 자산만 삭제할 수 있습니다. 삭제후 자산을 등록하십시요.!!");
		   return;
		}	
		
		if(!confirm('삭제하시겠습니까?')){	return;	}
		theForm.cmd.value = "d";
		theForm.action = "asset_master_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	
	// 상각재계산하기
	function RegDep(yn ){
		var theForm = document.form1;
		if (yn != '2' ) {
		   alert("상각진행중인 자산만 재계산할 수 있습니다.");
		   return;
		}	
		
		if(!confirm('상각재계산 하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "asset_dep_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name="form1" method="post" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="cmd" value="">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>
						자산보기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr> 
      <td align="right"> 
  
	  <a href="javascript:go_list(<%=asset_g%>);"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
      </td>
    </tr>
    <tr><td class=line2></td></tr>  
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width=15%>자산코드</td>
            <td width=35%>&nbsp; 
              <input type="text" name="asset_code" value="<%=bean.getAsset_code()%>" size="10" class=whitetext  maxlength="10">
            </td>
            <td class=title width=15%>구분</td>
            <td width=35%>&nbsp; 
              <select name="car_use" disabled>
                <option value="1" <%if(bean.getCar_use().equals("1"))%> selected<%%>>리스</option>
                <option value="2" <%if(bean.getCar_use().equals("2"))%> selected<%%>>렌트</option>
              </select>
            </td>
          </tr> 
          <tr>
            <td class=title>자산명칭</td>
            <td>&nbsp; 
              <input type="text" name="asset_name" value="<%=bean.getAsset_name()%>" size="60" class=whitetext  maxlength="10">
            </td>
            <td class=title>회계년도</td>
            <td>&nbsp;<input type="text" name="gisu" value="<%=bean.getGisu()%>" size="10" class=whitetext  maxlength="10">
            </td>	
          </tr>
          <tr> 
            <td class=title>자동차등록번호</td>
            <td>&nbsp; 
              <input type="text" name="car_no" value="<%=bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
            </td>
            <td class=title>최초자동차등록번호</td>
            <td>&nbsp;<input type="text" name="first_car_no" value="<%=bean.getFirst_car_no()%>" size="15" class=whitetext  maxlength="15">
            </td>	
          </tr>
          <tr> 
             <td class=title>취득형태</td>
            <td>&nbsp; 
              <select name="get_gubun" disabled>
                <option value="01" <%if(bean.getGet_gubun().equals("01"))%> selected<%%>>신규</option>
                <option value="02" <%if(bean.getGet_gubun().equals("02"))%> selected<%%>>중고</option>
              </select>
            </td>
            <td class=title>개별소비세</td>
            <td>&nbsp; 
   <%          if (bean.getPay_st().equals("1")){%>과세 <%}else if(bean.getPay_st().equals("2")){%>면세 <%}%>
                
            </td>	
          </tr>
          
          <tr> 
            <td class=title>구입처</td>
            <td>&nbsp; 
              <input type="text" name="ven_name" value="<%=bean.getVen_name()%>" size="10" class=whitetext maxlength="15">
            </td>
            <td class=title>취득일자</td> 
            <td>&nbsp;<input type="text" name="get_date"   value='<%=AddUtil.ChangeDate2(bean.getGet_date())%>'  size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
               &nbsp;&nbsp;출고일자:<%=AddUtil.ChangeDate2(bean.getDlv_dt())%>
            </td>
          </tr> 
          <tr> 
            <td class=title>내용연수</td>
            <td>&nbsp; 
              <input type="text" name="life_exist" value="<%=bean.getLife_exist()%>" size="10" class=text  maxlength="15">
            </td>
            <td class=title>상각율</td>
            <td>&nbsp;<input type="text" name="ndepre_rate"   value='<%=bean.getNdepre_rate()%>' class=text size="10"  ></td>
          </tr>  
       
          <tr> 
            <td class=title>상각방법</td>
            <td>&nbsp; 
              <select name="depr_method" disabled>
                <option value="1" <%if(bean.getDepr_method().equals("1"))%> selected<%%>>정액법</option>
                <option value="2" <%if(bean.getDepr_method().equals("2"))%> selected<%%>>정률법</option>
              </select>
            </td>
            <td class=title>상각계정코드</td>
            <td>&nbsp;<input type="text" name="gasset_code" value="<%=bean.getGasset_code()%>" size="10" class=whitetext  maxlength="10">
            </td>	
         </tr> 
         
         <tr> 
            <td class=title>취득(기초)가액</td>
            <td>&nbsp;  
              <input type="text" name="get_amt" value="<%=Util.parseDecimal(bean.getGet_amt())%>" size="15" class=whitetext  maxlength="15" >
            </td>
            <td class=title>취득수량</td>
            <td>&nbsp;<input type="text" name="guant" value="<%=bean.getGuant()%>" size="15" class=whitetext  maxlength="15">
            </td>	
          </tr>
          
         <tr> 
            <td class=title>상각완료여부</td>
            <td >&nbsp;<input type="hidden" name="deprf_yn" value="<%=bean.getDeprf_yn()%>" size="3" class=whitetext maxlength="5">
   <%         if (bean.getDeprf_yn().equals("1")){%>상각불가 <%}else if(bean.getDeprf_yn().equals("2")){%>상각진행 <%}else if( bean.getDeprf_yn().equals("4")){%>상각완료 <%}else if( bean.getDeprf_yn().equals("5")){%>당기처분 <%}else if( bean.getDeprf_yn().equals("6")){%>처분 <%}%>
  
            </td>
            <td class=title>손익</td>
            <td>&nbsp;
   <%     if (bean.getDeprf_yn().equals("5")){  
          				
				
    		for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
			
												
				if (String.valueOf(ht.get("GET_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {
				  t1 = 0;
				  t2 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              	} else {
                  t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
                  t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              	} 
				
								
				t4=AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
				t6=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
				t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				t12=AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));
								
				if ( ht.get("DEPRF_YN").equals("5")) {
					t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
					t7 = 0;
					t9 = 0;
				} else {
					t7 = t1 + t2 - t6 - t8;
					t9 = t6 + t8;
				}
				
				s1=AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
				
			//	f_sup_amt = AddUtil.parseFloat(String.valueOf(ht.get("SALE_AMT")))  /  AddUtil.parseFloat("1.1") ; //과세표준
			//	sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			//	sup_amt= (int) f_sup_amt;
	   		//	vat_amt = su_bean.getSale_amt() -  sup_amt;	//부가세	
	   		
	   			if (String.valueOf(ht.get("ASSCH_RMK")).equals("폐차") || String.valueOf(ht.get("ASSCH_RMK")).equals("폐기") ) {
					if ( !String.valueOf(ht.get("CLIENT_ID2")).equals("99")  ) {
							sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
					} else {					
							sup_amt = s1;
					}				
				} else {
					sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
				}
	   		
	      				
			}	
					
   %>        
   			<%=Util.parseDecimal(sup_amt - (t1 + t2 - t6 - t8 - t12) )%>  
   <%}%>        
           </td>
          
           </tr>             
                 
        </table>
      </td>
    </tr>   
</table>
<table>
<tr>
<td>
* 상각년수 및 상각방법, 상각율이 변동되는 경우 전산팀에 문의해야 합니다.
</td>
</tr>
</table>
</form>
<a href="javascript:OpenMove()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list_bd.gif" align="absmiddle" border="0"></a>&nbsp; 
<a href="javascript:OpenDep()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list_sg.gif" align="absmiddle" border="0"></a>&nbsp; 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% if ( asset_g.equals("1") && ( nm_db.getWorkAuthUser("전산팀",user_id)   || nm_db.getWorkAuthUser("자산관리",user_id) ) ) { %>
<a href="javascript:RegMove3(<%=bean.getDeprf_yn()%>)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg_pg.gif" align="absmiddle" border="0"></a>&nbsp; 
<% } %>
<% if ( asset_g.equals("1") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자산관리",user_id) ) ) { %>
<a href="javascript:RegMove(<%=bean.getDeprf_yn()%>)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg_bd.gif" align="absmiddle" border="0"></a>&nbsp; 
<% } %>
<% if ( asset_g.equals("1") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자산관리",user_id) ) ) { %>
<a href="javascript:RegDep(<%=bean.getDeprf_yn()%>)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_cal_sg.gif" align="absmiddle" border="0"></a>&nbsp;
<% } %>
<%  if ( user_id.equals("000063") ) {%>
<a href="javascript:RegMove4(<%=bean.getDeprf_yn()%>)" onMouseOver="window.status=''; return true">경매취소(복원)</a>&nbsp;
<!--<a href="javascript:RegMove5(<%=bean.getDeprf_yn()%>)" onMouseOver="window.status=''; return true">자산처리취소</a>&nbsp; 프로그램 확인해야 함. --> 
<% } %> 
</body>
</html>
