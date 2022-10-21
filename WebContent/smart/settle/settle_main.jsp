<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/cl_smain_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block;}
#menu_mn {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_mnt {float:left;  padding:10px 0 0 4px; color:#fff; font-weight:bold;}
#menu_tt {float:right; font-weight:bold; color:#fff; padding:10px 55px 0 0; position:absolute; right:0;}
#menu_tt em{color:#4ff5f3}
#menu_mrg {float:right;}


#gnb_sum {float:left; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/fms_smain_bg.gif);}
#gnb_tt {float:left; height:47px; font-size:0.95em; font-weight:bold; text-align:left;}
#gnb_t {float:left;  padding:15px 0 0 4px; color:#fff; font-weight:bold;}
#gnb_pr {float:right; font-weight:bold; color:#fff; padding:15px 55px 0 0; position:absolute; right:0;}
#gnb_pr em{color:#fde83a}
#gnb_mrg {float:right;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.List li {padding:0 21px;border-bottom:0px #eaeaea solid; color:#fff; font-weight:bold;}

</style>

<style type="text/css">
/*하이퍼링크 밑줄제거*/
A:link {text-decoration:none}
A:visited {text-decoration:none}
A:hover {text-decoration:none}
</style>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	user_bean = umd.getUsersBean(user_id);
	
	//내근직의 채권파트너
	UsersBean partner_bean = umd.getPartnerUsersBean(user_id);
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();
	
	
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 	= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	
	if(bus_id2.equals("")){
		
		if(user_bean.getLoan_st().equals("")){
			if(!partner_bean.getLoan_st().equals("")){
				bus_id2 = partner_bean.getUser_id();
			}
		}else{
			bus_id2 = user_id;
		}
	}
	
	String mode = "bus_id2";
	
	Vector vt = new Vector();
	
	if(!bus_id2.equals("")){
		vt = s_db.getStatSettleSubItemList	("", "", "", "", "", bus_id2, "", "", mode);//(String m_id, String l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String mode)
	}else{
		if(nm_db.getWorkAuthUser("임원",user_id)){
			mode = "";
			vt = s_db.getStatSettleSubItemList	("", "", "", "", "", bus_id2, "", "", mode);//(String m_id, String l_cd, String car_mng_id, String client_id, String site_id, String bus_id2, String gubun1, String mode)
		}
	}
	
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	
	long pre_amt 	= 0;
	long fine_amt 	= 0;
	long fee_amt 	= 0;
	long fee_amt2 	= 0;
	long serv_amt 	= 0;
	long cls_amt 	= 0;
	long rent_amt 	= 0;
	long accid_amt 	= 0;
	long dly_amt 	= 0;
	
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt += AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("선수금"))		pre_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("과태료"))		fine_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("대여료") && !String.valueOf(ht.get("GUBUN2")).equals("미청구+잔가"))		fee_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("대여료") && String.valueOf(ht.get("GUBUN2")).equals("미청구+잔가"))			fee_amt2 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("면책금"))		serv_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("해지정산금"))	cls_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("단기대여료"))	rent_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("휴/대차료"))	accid_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
			if(String.valueOf(ht.get("GUBUN1")).equals("연체이자"))		dly_amt 	+= AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
	}
	
		//get 방식으로 가기위해
	t_wd = "";
	s_kd = "";
	
	hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	hidden_value += "&bus_id2="+bus_id2+"";
			
%>
<script language='javascript'>
<!--
	function Search()
	{
		var fm = document.form1;		
		fm.action = "settle_main.jsp";
		fm.submit();
	}
	
	function view_info(s_item)
	{
		var fm = document.form1;		
		fm.s_item.value = s_item;				
		fm.action = "settle_item_list.jsp";
		<%if(vt_size>0){%>
		fm.submit();
		<%}else{%>
		alert('데이타가 없습니다.');
		<%}%>
	}
//-->
</script>
</head>
<body>
<form name="form1" method="post" action="">
<%@ include file="/smart/include/search_hidden.jsp" %>
  <input type='hidden' name='s_item'		value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(user_bean.getLoan_st().equals("")){%>
				<select name="bus_id2"  onChange='javascript:Search();'>
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                </select>
				<%}else{%>
				<%=user_bean.getUser_nm()%>
				<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
				<%}%>
				채권관리
			</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
    	<div id="gnb_sum">
    		<div id="gnb_tt"><img src="/smart/images/fms_smain_mrl.gif" alt="menu1" /></div>
        	<div id="gnb_t">합계</div>
        	<div id="gnb_pr"><em><%=AddUtil.parseDecimal(total_amt)%> 원</em></div>
        	 <div id="gnb_mrg"><img src="/smart/images/fms_smain_mrg.gif" alt="mrg" /></div>
        </div>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=선수금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
			<div id="menu_mnt">선수금</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(pre_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=과태료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">과태료</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(fine_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=면책금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
			<div id="menu_mnt">면책금</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(serv_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=연체이자">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">연체이자</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(dly_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=대여료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
			<div id="menu_mnt">대여료</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(fee_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=단기대여료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">단기대여료</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(rent_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=해지정산금">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">해지정산금</em></div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(cls_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=미청구+잔가">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
            <div id="menu_mnt">미청구+잔가</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(fee_amt2)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>		
		</a>
		<a href="settle_item_list.jsp<%=hidden_value%>&s_item=휴/대차료">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/cl_smain_mrl.gif" alt="menu1" /></div>
			<div id="menu_mnt">휴/대차료</div>
            <div id="menu_tt"><em><%=AddUtil.parseDecimal(accid_amt)%> 원</em></div>
            <div id="menu_mrg"><img src="/smart/images/cl_smain_mrg.gif" alt="mrg" /></div>
        </div>
		</a>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>
